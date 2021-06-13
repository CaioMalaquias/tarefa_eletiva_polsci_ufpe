# BIBLIOTECAS --------------------------------------------------------
library(data.table)
library(tidyverse)

# VALORES AUSENTES ---------------------------------------------------
db <- poliscidata::world

# Verificando NAs
db |> funModeling::status()

# criando shadow matrix (sm)
db_sm <-
  db|>
  is.na() |>
  abs() |>
  as.data.frame()
db_sm |> head()

y <- db_sm[which(sapply(db_sm, sd) > 0)]# mantém apenas variáveis que possuem NA
y |> cor() # observa a correlação entre variáveis

# OUTLIERS -----------------------------------------------------------

# carregar dados covid19 Pernambuco
COVID <- rio::import('https://dados.seplag.pe.gov.br/apps/basegeral.csv')

COVID_Mun <-
  COVID |>
  count(municipio, sort = T, name = 'casos') |>
  mutate(casos2 = sqrt(casos), casosLog = log10(casos))

## outliers em variáveis
# distância interquartil

plotly::plot_ly(y = COVID_Mun$casos2, type = "box", text = COVID_Mun$municipio, boxpoints = "all", jitter = 0.3)
boxplot.stats(COVID_Mun$casos2)$out
boxplot.stats(COVID_Mun$casos2, coef = 2)$out

COVIDOut <- boxplot.stats(COVID_Mun$casos2)$out
COVIDOutIndex <- which(COVID_Mun$casos2 %in% c(COVIDOut))
COVIDOutIndex

# filtro de Hamper
lower_bound <- median(COVID_Mun$casos2) - 3 * mad(COVID_Mun$casos2, constant = 1)
upper_bound <- median(COVID_Mun$casos2) + 3 * mad(COVID_Mun$casos2, constant = 1)
(outlier_ind <- which(COVID_Mun$casos2 < lower_bound | COVID_Mun$casos2 > upper_bound))

# teste de Rosner
covid19PERosner <- EnvStats::rosnerTest(COVID_Mun$casos2, k = 10)
covid19PERosner
covid19PERosner$all.stats

# Imputação ----------------------------------------------------------

## imputação numérica
# preparação da base, colocando NA aleatórios
COVID_DT <- COVID_Mun |> setDT() #copiar base iris, usando a data.table
COVID_DT <-
  COVID_DT |>
  select(municipio, casos2)

(COVIDNASeed <- round(runif(188, 1, 50))) # criando 188 valores aleatórios
(COVID_DT$casos2[COVIDNASeed] <- NA) # imputamos NA nos valores aleatórios

# tendência central
COVID_DT$casos2_mean <-
  COVID_DT$casos2 |>
  Hmisc::impute(fun = mean)
COVID_DT$casos2_median <-
  COVID_DT$casos2 |>
  Hmisc::impute(fun = median)

#Testando se os valores foram imputados
COVID_DT$casos2_mean |> Hmisc::is.imputed() |> table()
COVID_DT$casos2_median |> Hmisc::is.imputed() |> table()

## Hot deck
# imputação aleatória
(COVID_DT$casos2_random <- impute(COVID_DT$casos2, "random"))
# imputação por instâncias
COVID_DT2 <- COVID_DT |> VIM::kNN()

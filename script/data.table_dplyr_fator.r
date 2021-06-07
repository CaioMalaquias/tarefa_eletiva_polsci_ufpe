# Bibliotecas ---

library(data.table)
library(tidyverse)
library(ade4)
library(arules)

# Criando base ---
semente <- addTaskCallback(function(...) {set.seed(99);TRUE}) #cria/roda semente
#~~cria data frame do banco de dados puro
BD_RAW <- data.frame(votoTipo = sample(c(0:3), 100, replace = TRUE),
                     renda = rnorm(n = 100, mean = 1000, sd = 90),
                     idade = rnorm(n = 100, mean = 25, sd = 5),
                     sexo  = sample(c("Masc", "Fem"), 100, replace = TRUE))
removeTaskCallback(semente) # para semente

# Tipos e Fatores -------------------------------------------------
votoCode <- c(ideologico = 0, estrategico = 1, retrospectivo = 2, economico = 3)

bd <-
  BD_RAW |>
  mutate(votoTipo = factor(votoTipo, levels = votoCode, labels = names(votoCode)),
         sexo = as.factor(sexo))

# Mais Fatores ---------------------------------------------------
# One Hot Encoding

bdFatores <- sapply(bd, is.factor)
bdFatores <- bd[ , bdFatores]

bdDummy <- bdFatores |> acm.disjonctif()

# transformação dos fatores de uma base de dados em 3 tipos:
# mais frequente, segundo mais frequente e outros
bd$votoTipo |> fct_lump(n = 2)

# Dplyr --------------------------------------------------------------
bd |>
  filter(idade >= 18) |> # manipulação de casos
  group_by(votoTipo, sexo) |> # agrupamento
  summarise(mediarenda = mean(renda, na.rm = TRUE),
            MediaIdAde = mean(idade, na.rm = TRUE)) |> # sumário
  rename(rendaMedia = mediarenda, # manipulação da variável mediarenda
         idadeMedia = MediaIdAde) # manipulação da variável MediaIdAde

# Data Table ---------------------------------------------------------
bdDT <- bd |> setDT()
# Regressão
regbd <- bdDT[ ,lm(formula = votoTipo ~ renda + idade + sexo)]

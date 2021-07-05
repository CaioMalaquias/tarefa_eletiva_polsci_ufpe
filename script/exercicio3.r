# Bibliotecas-Base ----
library(data.table)
library(tidyverse)
library(plotly)
# leitura do arquivo ----
bd <- rio::import("raw_data/basegeral.csv")

# imputação aleatória "correção" dos NAs ----
bd$sintomas_rd <-
  bd$dt_primeiros_sintomas |>
  Hmisc::impute(fun = "random")
bd |> head(50) |> View()

# contando número de casos confirmados e negativos, por município ----
bd |>
  select(cd_municipio, classe) |>
  filter(classe == "CONFIRMADO" | classe == "NEGATIVO") |>
  group_by(cd_municipio, classe) |>
  tally()

# encontra "tosse" na variável sintomas ----
bd <-
  bd |>
  mutate(tosse = stringr::str_detect(string = bd$sintomas, pattern = "TOSSE"))
# casos confirmados/negativos com tosse
bd |>
  select(classe, tosse) |>
  filter(classe == "CONFIRMADO" | classe == "NEGATIVO", tosse == TRUE) |>
  group_by(classe) |>
  tally()

# fiquei na dúvida se era pra manter as subdivisões anterioes, então tá aqui:
bd |>
  select(cd_municipio, classe, tosse) |>
  filter(classe == "CONFIRMADO", tosse == TRUE) |>
  group_by(cd_municipio, classe) |>
  tally()

# média móvel 7 dias confirmados e negativos
# agrupando para todo o estado
bd_PE <-
  bd |>
  select(dt_notificacao, classe) |>
  filter(classe == "CONFIRMADO" | classe == "NEGATIVO") |>
  group_by(dt_notificacao, classe) |>
  mutate(n_casos = n())

bd_PE <-
  bd_PE |>
  mutate(casos_mm7 = round(zoo::rollmean(x = n_casos, 7,align = "right",
    fill = NA), 2)) # média móvel de 7 dias

bd_PE |>
  plot_ly() |>
  add_trace(x = ~ dt_notificacao, y = ~ casos_mm7, color = ~ classe,
            type = 'scatter', mode = 'lines') |>
  layout(
    title = 'casos confirmados e negativos - COVID-19',
    xaxis = list(title = 'Data', showgrid = FALSE),
    yaxis = list(title = 'número de casos', showgrid = FALSE),
    hovermode = "compare") 

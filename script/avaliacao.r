# bibliotecas-base ----
library(tidyverse)
library(lubridate)

# extraindo da página e lendo tabela ----
bd_raw <- rio::import("https://dados.seplag.pe.gov.br/apps/basegeral.csv")
pop_mun_raw <- rio::import("raw_data/avaliacao_tabela.csv", encoding = "UTF-8")

# wrangling ----
# (bd) base de dados de covid
bd <- 
  bd_raw |> 
  mutate(municipio = stringi::stri_trans_general(bd_raw$municipio, "Latin-ASCII"),
         municipio = stringr::str_to_lower(string = bd_raw$municipio))
# semana epidemiológica
bd <- bd |>
  mutate(semana = case_when(dt_notificacao < date("2021-01-01") ~ week(bd$dt_notificacao),
                            dt_notificacao >= date("2021-01-01") ~ week(bd$dt_notificacao) + 52))

# (pop_mun) tabela de populacao dos municipios
pop_mun <- pop_mun_raw |> slice(c(-1, -2, -3, -4, -5, -5576)) # remove linhas desnecessárias
colnames(pop_mun) <- c("municipio", "populacao")
pop_mun <- pop_mun |> 
  filter(stringr::str_detect(municipio, "(PE)")) # apenas municípios de PE
pop_mun <- pop_mun |> 
  mutate(municipio = stringi::stri_trans_general(pop_mun$municipio, "Latin-ASCII"),
         municipio = stringr::str_to_lower(string = municipio),
         municipio = str_remove(string = municipio, pattern = " \\(pe\\)"),
         populacao = as.numeric(populacao))

# merge (mesmo utilizando o fuzzyjoin, preferiu-se fazer uma limpeza prévia, 
# removendo acentos e deixando todas as letras dos nomes dos municípios minúsculas)
bd <- fuzzyjoin::stringdist_join(bd, pop_mun, mode = "left", by = "municipio")
bd <- bd |> rename(municipio = municipio.x)
rm(list=setdiff(ls(), "bd")) # limpando environment

# Análise ----
# 2.1 Calcule, para cada município do Estado, o total de casos confirmados 
# por semana epidemiológica
bd |>
  select(municipio, semana, classe) |>
  filter(classe == "CONFIRMADO") |>
  group_by(municipio, semana) |>
  tally() |>
  View()
# 2.2 Calcule, para cada município do Estado, o total de óbitos confirmados 
# por semana epidemiológica
bd |>
  select(municipio, semana, evolucao) |>
  filter(evolucao == "OBITO") |>
  group_by(municipio, semana) |>
  tally() |>
  View()

# 4.1 Calcule a incidência por município a cada semana epidemiológica
bd |>
  select(municipio, semana, classe, populacao) |>
  filter(classe == "CONFIRMADO") |>
  group_by(municipio, semana) |> 
  summarise(incidencia = (n()/populacao)*100000) |> View()

# 4.2 Calcule a letalidade por município a cada semana epidemiológica
bd |>
  select(municipio, semana, evolucao, populacao) |>
  filter(evolucao == "OBITO") |>
  group_by(municipio, semana) |> 
  summarise(letalidade = (n()/populacao)*100000) |> View()
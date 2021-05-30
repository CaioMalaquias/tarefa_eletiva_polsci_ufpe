
# bibliotecas -------------------------------------------------------------
library(funModeling)
library(tidyverse)
library(validate)

# DESCOBERTA --------------------------------------------------------------
sinistrosRecife_RAW

glimpse(sinistrosRecife_RAW) # Olhando os dados
status(sinistrosRecife_RAW) # Olhando a estrutura dos dados
freq(sinistrosRecife_RAW) # Frequência de variáveis em fator
plot_num(sinistrosRecife_RAW) # Explorando as variáveis numéricas
profiling_num(sinistrosRecife_RAW) # Estatísticas de variáveis numéricas

# ESTRUTURAÇÃO ------------------------------------------------------------
sinistrosRecife <-
  sinistrosRecife_RAW |>
  select(bairro, natureza_acidente, vitimas) |>
  filter(natureza_acidente != "VÍTIMA FATAL") |> # LIMPEZA
  drop_na() # LIMPEZA

sinistrosRecife <-
  sinistrosRecife |>
  group_by(bairro, natureza_acidente) |>
  summarise(vitimas = sum(vitimas, na.rm = TRUE)) |>
  pivot_wider(names_from = natureza_acidente,
              values_from = vitimas) |>
  rename(com_vitima = `COM VÍTIMA`,
         sem_vitima = `SEM VÍTIMA`)

# LIMPEZA -----------------------------------------------------------------
#>>> O processo de limpeza ocorreu na:
#>>> linha 18: remoção da categoria "vítima fatal"
#>>> linha 19: remoção dos missing values para bairro e natureza_acidente

# ENRIQUECIMENTO ----------------------------------------------------------
# criando data frame para executar a tarefa de join
nomeBairros <-
  sinistrosRecife$bairro |>
  unique()

semente <- addTaskCallback(function(...) {set.seed(99);TRUE})
dadosBairros <- data.frame(bairro = nomeBairros,
                           area_bairro = rnorm(n = 92, mean = 90, sd = 2),
                           idade_bairro = rnorm(n = 92, mean = 40, sd = 5))
removeTaskCallback(semente) # fim semente

# ENRIQUECIMENTO
sinistrosRecife <-
  sinistrosRecife |>
  left_join(dadosBairros)

# VALIDAÇÃO ----------------------------------------------------------
# criando regras de validação
regrasValidacaoSinistros <-
  validator(com_vitima > 0,
            sem_vitima == 0)

# confront
validacao <-
  confront(sinistrosRecife, regrasValidacaoSinistros)

# conferindo validação
validacao |> summary()
validacao |> plot()

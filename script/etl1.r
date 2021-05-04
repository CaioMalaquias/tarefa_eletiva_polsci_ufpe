
# ETL REAL ----------------------------------------------------------------
library(magrittr)
library(dplyr)
# carrega a base de snistros de transito do site da PCR
#
#sinistrosRecife2015Raw <- read.csv2('http://dados.recife.pe.gov.br/dataset/44087d2d-73b5-4ab3-9bd8-78da7436eed1/resource/db610fdc-18fa-41a1-9b26-72038c56ffc8/download/acidentes-transito-2015.csv', sep = ';', encoding = 'UTF-8')
#sinistrosRecife2016Raw <- read.csv2('http://dados.recife.pe.gov.br/dataset/44087d2d-73b5-4ab3-9bd8-78da7436eed1/resource/61ca6a8b-1648-44a5-87db-431777b33144/download/acidentes_2016.csv', sep = ';', encoding = 'UTF-8')
#sinistrosRecife2017Raw <- read.csv2('http://dados.recife.pe.gov.br/dataset/44087d2d-73b5-4ab3-9bd8-78da7436eed1/resource/ff3429de-2dda-4747-b35d-aa51bbf8d1f4/download/acidentes_2017.csv', sep = ';', encoding = 'UTF-8')
sinistrosRecife2018Raw <- read.csv2('http://dados.recife.pe.gov.br/dataset/44087d2d-73b5-4ab3-9bd8-78da7436eed1/resource/2485590a-3b35-4ad0-b955-8dfc36b61021/download/acidentes_2018.csv', sep = ';', encoding = 'UTF-8')
sinistrosRecife2019Raw <- read.csv2('http://dados.recife.pe.gov.br/dataset/44087d2d-73b5-4ab3-9bd8-78da7436eed1/resource/3531bafe-d47d-415e-b154-a881081ac76c/download/acidentes-2019.csv', sep = ';', encoding = 'UTF-8')
sinistrosRecife2020Raw <- read.csv2('http://dados.recife.pe.gov.br/dataset/44087d2d-73b5-4ab3-9bd8-78da7436eed1/resource/fc1c8460-0406-4fff-b51a-e79205d1f1ab/download/acidentes_2020-novo.csv', sep = ';', encoding = 'UTF-8')
sinistrosRecife2021Raw <- read.csv2('http://dados.recife.pe.gov.br/dataset/44087d2d-73b5-4ab3-9bd8-78da7436eed1/resource/2caa8f41-ccd9-4ea5-906d-f66017d6e107/download/acidentes_2021-jan.csv', sep = ';', encoding = 'UTF-8')
# Remover as colunas diferentes de 2018 e 2019
sinistrosRecife2018Raw <- sinistrosRecife2018Raw %>% select(-10, -11, -12)
sinistrosRecife2019Raw <- sinistrosRecife2019Raw %>% select(-10, -11, -12)
# Renomear DATA para data em 2018 e 2019
colnames(sinistrosRecife2018Raw)[1] <- "data"
colnames(sinistrosRecife2019Raw)[1] <- "data"
# junta as bases de dados com comando rbind (juntas por linhas)
sinistrosRecifeRaw <- rbind(sinistrosRecife2018Raw, sinistrosRecife2019Raw,
                            sinistrosRecife2020Raw, sinistrosRecife2021Raw)
# observa a estrutura dos dados
str(sinistrosRecifeRaw)
# modifca a data para formato date
sinistrosRecifeRaw$data <- as.Date(sinistrosRecifeRaw$data, format = "%Y-%m-%d")

# modifica natureza do sinistro de texto para fator
sinistrosRecifeRaw$natureza_acidente <-
  as.factor(sinistrosRecifeRaw$natureza_acidente)
sinistrosRecifeRaw$bairro <-
  as.factor(sinistrosRecifeRaw$bairro)

# cria funçaõ para substituir not available (na) por 0
naZero <- function(x) {
  x <- ifelse(is.na(x), 0, x)
}

# aplica a função naZero a todas as colunas de contagem
sinistrosRecifeRaw[, 15:25] <- sapply(sinistrosRecifeRaw[, 15:25], naZero)

# EXTRAÇÃO -----------------------------------------------------------------

ls() # lista todos os objetos no R
# vamos ver quanto cada objeto está ocupando
for (itm in ls()) {
  print(formatC(c(itm, object.size(get(itm))),
                format="d",
                width=30),
        quote=F)
}

rm(list = c('sinistrosRecife2020Raw', 'sinistrosRecife2021Raw'))

saveRDS(sinistrosRecifeRaw, "bases_tratadas/sinistrosRecife.rds")
write.csv2(sinistrosRecifeRaw, "bases_tratadas/sinistrosRecife.csv")

# LEITURA -----------------------------------------------------------------

# arquivos em formato nativo do R têm a vantagem de ser otimizado para o R, o
# que gera melhor desempenho computacional (no caso, usa menos menória RAM), e a
# desvantagem é ser restrito ao R
#
# formatos não nativos são o oposto: menor eficiência que os nativos, porém
# com a grande vantagem de serem utilizados em outros sistemas e linguagens

library(rio)
export(x = sinistrosRecifeRaw, file = "sinistrosRecife.csv")
import("sinistrosRecife.csv")

# benchmark
install.packages("microbenchmark")
library(microbenchmark)
library(readxl)

#benchmark das funções de exportação saveRDS, write.csv2, e export
microbenchmark(a <- saveRDS(sinistrosRecifeRaw, "sinistrosRecife.rds"),
               b <- write.csv2(sinistrosRecifeRaw, "sinistrosRecife.csv"),
               c <- export(x = sinistrosRecifeRaw, file = "sinistrosRecife.csv"),
               times = 30L)
# a função do pacote rio foi 5 vezes mais rápida. até mesmo ao salvar um csv
# comparado com o arquivo rds

#benchmark das funções de leitura readRDS, read.csv2, e import
microbenchmark(a <- readRDS('sinistrosRecife.rds'),
               b <- read.csv2('sinistrosRecife.csv', sep = ';'),
               c <- import("sinistrosRecife.csv"),
               times = 30L)

# ETL TEÓRICO -------------------------------------------------------------
# ~Extração~ é a área voltada para a captura dos dados de alguma fonte. Cuidados
# com a formatação inicial e validação são essenciais.
# ~Transformação~ é o preparo dos dados para o futuro carregamento. Aqui é
# importante e necessário o conhecimento prévio do objetivo do projeto como um
# todo, para melhor selecionar e tratar os dados.
# ~Load~ é o carregamento dos dados em alguma plataforma, e em algum formato
# acessível para a equipe que os vai utilizar.
# na ELT, os dados são carregados primeiro, e o tratamento ocorre depois. Isso é
# especialmente útil quando a equipe de analytics - ou várias outras equipes
# secundárias - utilizarão muitas variáveis com diferentes níveis e tipos de
# tratamento, de modo que inviabilizaria o tratamento pela equipe que os
# carregou. Um tratamento prévio poderia suprimir informações úteis.

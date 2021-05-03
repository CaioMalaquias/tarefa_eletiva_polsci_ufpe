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

# exporta em formato nativo do R
saveRDS(sinistrosRecifeRaw, "bases_tratadas/sinistrosRecife.rds")

# exporta em formato tabular (.csv) - padrão para interoperabilidade
write.csv2(sinistrosRecifeRaw, "bases_tratadas/sinistrosRecife.csv")

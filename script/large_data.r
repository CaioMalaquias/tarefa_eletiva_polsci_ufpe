library(data.table)

setwd("C:/Users/CaioM/github/etl_com_r")

# cria dado com mais de 1 GB
Cadastro <-
  data.frame(
    genero = sample(c("Masc", "Fem"), 40000000, replace = TRUE),
    idade = rnorm(n = 40000000, mean = 25, sd = 5),
    salario = rnorm(n = 40000000, mean = 1200, sd = 20),
    filhosDummy = sample(c("Sim", "Não"), 40000000, replace = TRUE),
    covidDummy = rbinom(40000000, 1, .2))

write.csv2(Cadastro, "bases_originais/CadastroCovid.csv")

# extração direta via read.csv2
system.time(extracaoLD1 <- read.csv2("bases_originais/CadastroCovid.csv"))
object.size(extracaoLD1)

# extração via amostragem com read.csv
amostraLD2 <- read.csv2("bases_originais/fobhav.csv", nrows = 20)
amostraLD2Classes <- sapply(amostraLD1, class) # encontra a classe da amostra amostra
system.time(extracaoLD2 <- data.frame(read.csv2("bases_originais/CadastroCovid.csv", colClasses=amostraLD1Classes)))
object.size(extracaoLD2)

# extração via função fread, que já faz amostragem automaticamente
system.time(extracaoLD3 <- fread("bases_originais/CadastroCovid.csv"))
object.size(extracaoLD3)

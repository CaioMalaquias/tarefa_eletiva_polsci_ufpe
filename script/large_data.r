install.packages("ff")
install.packages("ffbase")

library(ff)
library(ffbase)

enderecoBase <- 'bases_originais/largeData.csv'

# criando o arquivo ff
extracaoLD4 <- read.csv.ffdf(file=enderecoBase)

sum(extracaoLD4[,1])
mean(extracaoLD4[,2])
sqrt(extracaoLD4[,3])# aqui é matemática individual

# amostra com 180 casos. 30 para cada coeficiente da regressão futura
# ia ser massa fazer um bootstrap disso. acho que vai ser a próxima aula
LD4sample180 <- extracaoLD4[sample(nrow(extracaoLD4), 180) , ]
#regressão
lm(c ~ ., LD4sample180)

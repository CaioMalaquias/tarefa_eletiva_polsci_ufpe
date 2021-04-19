# Pacotes -----------------------------------------------------------------
install.packages("caret", dependencies = TRUE)
library(caret)

# Cria variáveis (as mesmas do exercício anterior) ------------------------
semente <- addTaskCallback(function(...) {set.seed(99);TRUE}) #cria/roda semente
#~~cria data frame de cadastro
cadastro <- data.frame(ID = sample(c(000:999), 100, replace = TRUE),
                       genero = sample(c("Masc", "Fem"), 100, replace = TRUE),
                       idade = rnorm(n = 100, mean = 25, sd = 5))
removeTaskCallback(semente) # para semente

# Bootstrapping (bts = bootstrapping) ---------------------------------------
set.seed(11)
# calculando média das idades dos indivíduos no cadastro
bts_cadastro <- replicate(20, mean(sample(x = cadastro$idade, size = 30,
                                          replace = FALSE)))
# Partições ---------------------------------------------------------------
particaoIdade <- createDataPartition(1:length(cadastro$idade), p=.7)
# partição de treino
treinoIdade <- cadastro$idade[unlist(particaoIdade)]
# partição de teste
testeIdade <- cadastro$idade[-unlist(particaoIdade)]

#~~ Tarefa para criar vetor, função, e mostrar características de objetos
# vetor
vetor <- c(100)
# características do vetor vetor
str(vetor)

#modelo de regressão com a base de dados iris
lmIris <- lm(Sepal.Length ~ ., iris) # criação de um modelo de regressão

# visualização das caracteristicas do iris e do modelo de regressão
str(iris)
str(lmIris)

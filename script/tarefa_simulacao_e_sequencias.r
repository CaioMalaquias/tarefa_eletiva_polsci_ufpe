semente <- addTaskCallback(function(...) {set.seed(99);TRUE}) #cria/roda semente

varNormal <- rnorm(99) # variável normal
varBinomial <- rbinom(99, 9, .9) # variável binomial
varIndex <- seq(1, length(varBinomial))# variável indexadora

removeTaskCallback(semente) # para semente

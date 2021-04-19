semente <- addTaskCallback(function(...) {set.seed(99);TRUE}) #cria/roda semente
#~~cria data frame de cadastro
Cadastro <- data.frame(ID = sample(c(000:999), 100, replace = TRUE),
                       genero = sample(c("Masc", "Fem"), 100, replace = TRUE),
                       idade = rnorm(n = 100, mean = 25, sd = 5))
removeTaskCallback(semente) # para semente

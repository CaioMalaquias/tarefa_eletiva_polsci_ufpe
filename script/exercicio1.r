library(magrittr)
# Cria variáveis (as mesmas do exercício anterior) ------------------------
semente <- addTaskCallback(function(...) {set.seed(99);TRUE}) #cria/roda semente
# 1. Crie um data frame com pelo menos 500 casos e a seguinte composição: duas 
# variáveis normais de desvio padrão diferente, uma variável de contagem
# (poisson), uma variável de contagem com dispersão (binomial negativa), uma
# variável binomial (0,1), uma variável qualitativa que apresenta um valor
# quando a variável binomial é 0 e outro quando é 1, e uma variável de index.
# >>>> As variáveis (normais, contagem e binomial) devem ser simuladas!!!
df <- data.frame(normal1 = rnorm(n = 500, mean = 0, sd = 1),
                normal2 = rnorm(n = 500, mean = 0, sd = 2),
                poisson = rpois(n = 500, lambda = 1),
                binomialNegativa = rnbinom(n = 500, mu = 1, size = 1),
                binomial = rbinom(n = 500, size = 1, prob = .5))
df$quali <- ifelse(test = df$binomial == 1, yes = "pena", no = "escama")
df$varIndex <- seq(1, length(df$normal1))# variável indexadora
removeTaskCallback(semente) # para semente

# 2. Centralize as variáveis normais.
# 3. Troque os zeros (0) por um (1) nas variáveis de contagem.
df <-
df %>%
  mutate(normal1 = scale(x = normal1, center = TRUE, scale = FALSE),
         normal2 = scale(x = normal2, center = TRUE, scale = FALSE),
         poisson = ifelse(test = poisson == 0, yes = 1, no = poisson),
         binomialNegativa = ifelse(test = binomialNegativa == 0, yes = 1,
                                   no = binomialNegativa))

# 4. Crie um novo data.frame com amostra (100 casos) da base de dados original.
amostra_df <- sample(x = df, size = 100, replace = TRUE)
# Compartilhe com a gente o seu endereço de github com o código do exercícicio!!

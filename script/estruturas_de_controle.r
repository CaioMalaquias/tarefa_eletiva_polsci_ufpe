# controle condicional
# faz uma dummy indicando comprimento da sépala pequeno (menores que 6)
irisCopia <- iris
irisCopia$Small.Sep.Len_dummy <- ifelse(iris$Sepal.Length < 6, 1, 0)

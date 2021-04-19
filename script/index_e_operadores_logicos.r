# tarefa para utilizar indexações e operadores lógicos ----------------------
# faz o sumário apenas da variável de interesse (coluna 3)
summary(iris[[3]])

# mostra as larguras de sépala para os casos em que o comprimento é menor que 6
iris$Sepal.Width[iris$Sepal.Length < 6]

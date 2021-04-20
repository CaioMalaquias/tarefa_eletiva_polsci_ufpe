# gráficos do mtcars para exercitar lapply()
par(mfrow = c(5, 2))
lapply(mtcars[, 1:10], hist)

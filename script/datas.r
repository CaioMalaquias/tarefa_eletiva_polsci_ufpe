library(tidyverse)

# INTRO DATAS TEMPOS -------------------------------------------------
# CONVERSÕES
data1 <- c("2013-10-19 10:25", "2001-12-07 19:25") |> as.Date() # texto->data
data2 <- c("2000-10-19 eae", "1999-12-07 19:25") |> as.Date() # texto->data
data_ct <- c(data1, data2) |> as.POSIXct() # POSIXct
data_lt <- c(data1, data2) |> as.POSIXlt() # POSIXlt

# EXTRAÇÕES
data_ct |> lubridate::year() # ano
data_ct |> lubridate::wday() # dia da semana (número)
data_lt |> lubridate::isoweek() # semana ISO

# DATAS NA PRÁTICA ---------------------------------------------------
###
url = 'https://raw.githubusercontent.com/wcota/covid19br/master/cases-brazil-states.csv' # passar a url para um objeto
covidBR = url |> read.csv2(encoding='latin1', sep = ',') # baixar a base de covidBR
covidSC <- covidBR |> filter(state == 'SC') # filtrar para Santa Catarina
# modificar a coluna data de string para date
covidSC$date <- covidSC$date |> as.Date(format = "%Y-%m-%d")
covidSC$dia <- seq(1:length(covidSC$date)) # criar um sequencial de dias de acordo com o total de datas para a predição
covidSC$letalidade <- covidSC$newDeaths/covidSC$newCases
# criar segundo vetor auxiliar
predDia = rbind(data.frame(dia = covidSC$dia),
                data.frame(dia = seq(max(covidSC$dia) + 1,
                                     max(covidSC$dia) + 180)))

fitLL <- drm(formula = newCases ~ dia, fct = LL2.5(),
             data = covidSC, robust = 'mean') # fazendo a predição log-log com a função drm
plot(fitLL, log="", main = "Log logistic") # observando o ajuste

predLL <- data.frame(predicao = ceiling(predict(fitLL, predDia))) # usando o modelo para prever para frente, com base no vetor predDia
predLL$data <- seq.Date(as.Date('2020-03-12'), by = 'day', length.out = length(predDia$dia)) # criando uma sequência de datas para corresponder aos dias extras na base de predição

predLL <- merge(predLL, covidSC, by.x ='data', by.y = 'date', all.x = T) # juntando as informações observadas da base original

predLL |> plotly::plot_ly() |>
  add_trace(x = ~data, y = ~predicao, type = 'scatter',
            mode = 'lines', name = "Novos Casos - Predição") |>
  add_trace(x = ~data, y = ~newCases, name = "Novos Casos - Observados", mode = 'lines') |>
  layout(
    title = 'Predição de Novos Casos de COVID-19 em Santa Catarina',
    xaxis = list(title = 'Data', showgrid = FALSE),
    yaxis = list(title = 'Novos Casos por Dia', showgrid = FALSE),
    hovermode = "compare") # plotando tudo junto, para comparação

# média móvel
covidSC <-
  covidSC |>
  mutate(letalidadeMM7 = round(rollmean(x = letalidade, 7,align = "right", fill = NA), 2)) # média móvel de 7 dias

covidSC <-
  covidSC |>
  mutate(letalidadeLag7 = dplyr::lag(letalidade, 7)) # valor defasado em 7 dias

covidSC |>
  plotly::plot_ly() |>
  add_trace(x = ~date, y = ~letalidade,
            type = 'scatter', mode = 'lines', name = "Letalidade") |>
  add_trace(x = ~date, y = ~letalidadeMM7, name = "Letalidade Média Móvel (7)", mode = 'lines') |>
  layout(
    title = 'Letalidade (mortes/casos) de COVID19 em Santa Catarina',
    xaxis = list(title = 'Data', showgrid = FALSE),
    yaxis = list(title = 'Taxa de Letalidade', showgrid = FALSE),
    hovermode = "compare") # plotando tudo junto, para comparação

# série temporal
(covidSCTS <-
    covidSC$letalidade |>
    xts::xts(covidSC$date)) # transformar em ST
str(covidSCTS)
autoplot(covidSCTS)
acf(covidSCTS)

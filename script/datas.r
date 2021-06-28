# CONVERSÕES
data1 <- c("2013-10-19 10:25", "2001-12-07 19:25") |> as.Date() # texto->data
data2 <- c("2000-10-19 eae", "1999-12-07 19:25") |> as.Date() # texto->data
data_ct <- c(data1, data2) |> as.POSIXct() # POSIXct
data_lt <- c(data1, data2) |> as.POSIXlt() # POSIXlt

# EXTRAÇÕES
data_ct |> lubridate::year() # ano
data_ct |> lubridate::wday() # dia da semana (número)
data_lt |> lubridate::isoweek() # semana ISO

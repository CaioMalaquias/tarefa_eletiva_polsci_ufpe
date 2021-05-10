
# Extração simples -------------------------------------------------------------

library(rio)
# xml
importXML <- import("http://aiweb.cs.washington.edu/research/projects/xmltk/xmldata/data/auctions/321gone.xml")
# TXT
importTXT <- import("https://filesamples.com/samples/document/txt/sample3.txt", sep = "\n")
# CSV
importCSV <- import('http://dados.recife.pe.gov.br/dataset/44087d2d-73b5-4ab3-9bd8-78da7436eed1/resource/fc1c8460-0406-4fff-b51a-e79205d1f1ab/download/acidentes_2020-novo.csv', sep = ';', encoding = 'UTF-8')


# Extração ----------------------------------------------------------------
library(rvest)

url <- "https://en.wikipedia.org/wiki/The_Office_(American_TV_series)"
urlTable <- url %>% read_html %>% html_nodes("table")
temporadasOffice <- as.data.frame(html_table(urlTable[4]))
temporadasOffice <- temporadasOffice[-1,]


# Carga Incremental -------------------------------------------------------

#A chave é o número da temporada, mas vou criar uma para fazer a tarefa toda
temporadasOffice$chave <-
  apply(temporadasOffice[,c(4, 6)], MARGIN = 1,
        FUN = function(i) paste(i, collapse = ""))
# criando base "nova" e "antiga"
temporadasOffice_NOVA <- temporadasOffice
temporadasOffice_VELHA <- temporadasOffice[-3,]
# comparando as bases
incremento <- setdiff(temporadasOffice_NOVA, temporadasOffice_VELHA)
# Juntando a base antiga com o incremento do setdiff
temporadasOffice_VELHA <- rbind(temporadasOffice_VELHA, incremento)

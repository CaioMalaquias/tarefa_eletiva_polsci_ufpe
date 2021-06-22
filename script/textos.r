
# Parte 1 -----------------------------------------------------------
pdf_RAW <- textreadr::read_pdf('docs/pdf_r.pdf', ocr = T)

# agrupando páginas
pdf <-
  pdf_RAW |>
  group_by(element_id) |>
  mutate(all_text = paste(text, collapse = " | ")) |>
  select(element_id, all_text) |>
  unique()

# extraindo datas
datas <- pdf$all_text |> str_extract_all("\\d{2}/\\d{2}/\\d{2}")

# mudando barra por hífen
datas_hifen <- datas |> str_replace_all(pattern = "/", replacement = "-")


# Parte 2 ------------------------------------------------------------

cor <- c("Amarelo", "Branco", "Creme", "Dourado", "Esmeralda")
tom <- c("claro", "escuro", "claro","Escuro", "claro")
qtd <- c(7, 30, 80, 12, 3)

informacao <- data.frame(cor, tom, qtd)

cor <- c("Amarela", "Creminho", "Branca", "Esmeraldina", "Dourada")
valor <- c(30, 30, 50, 35, 40)

valores <- data.frame(cor, valor)

# juntando bases (fuzzy)

info_valor <- fuzzyjoin::stringdist_join(informacao, valores, mode='left') # apelei no creminho, eu sei

# filtro
info_valor_A1 <-
  info_valor |>
  mutate(tag_tom = ifelse(grepl(paste("claro", collapse="|"), tom), '1', '0'))

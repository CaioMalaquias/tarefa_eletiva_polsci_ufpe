#### Staging area e uso de memória

# ficamos com staging area??

ls() # lista todos os objetos no R

# vamos ver quanto cada objeto está ocupando

for (itm in ls()) {
  print(formatC(c(itm, object.size(get(itm))),
                format="d",
                width=30),
        quote=F)
}

# agora, vamos remover

gc() # uso explícito do garbage collector
rm(list = setdiff(ls(), c("sinistrosRecifeRaw", "naZero")))

saveRDS(sinistrosRecifeRaw, "bases_tratadas/sinistrosRecife.rds")

write.csv2(sinistrosRecifeRaw, "bases_tratadas/sinistrosRecife.csv")

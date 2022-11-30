setwd("~/MCnebula2/R")
library(magrittr)

script <- list.files(".", pattern = "\\.R$") %>% 
  sapply(readLines)

target <- lapply(script,
                 function(text){
                   sig <- 0
                   for (i in 1:length(text)) {
                     if (grepl("^#", text[i])) {
                       if (sig == 2) {
                         sig <- 1
                         text[i] <- paste0("\n", text[i])
                       }
                       next
                     }
                     if (grepl("^NULL", text[i]))
                       next
                     if (grepl("^$", text[i])) {
                       sig <- 1
                       next
                     }
                     if (grepl("^[a-z|A-Z|.]", text[i])) {
                       if (grepl("^setGeneric", text[i]))
                         break
                       if (sig == 2) {
                         text[i] <- paste0("\n", text[i])
                       }
                       sig <- 2
                     }
                   }
                   return(text)
                 })

writeLines(target[[3]])

path <- "~/code_backup/mcnebula2"
dir.create(path, recursive = T)

lapply(names(target),
       function(name){
         writeLines(target[[name]], paste0(path, "/", name))
       })


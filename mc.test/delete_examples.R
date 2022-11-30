setwd("~/MCnebula2/R")
library(magrittr)

script <- list.files(".", pattern = "\\.R$") %>% 
  sapply(readLines)

target <- 
  lapply(script,
         function(text){
           sig <- 0
           if_exam <- rep(F, length(text))
           for (i in 1:length(text)) {
             if (!grepl("^#'", text[i])) {
               next
             }
             if (grepl("^#' @examples", text[i])) {
               sig <- 2
               if_exam[i] <- T
               next
             }
             if (sig == 2) {
               if (grepl("^#' @", text[i])) {
                 sig <- 1
               } else {
                 if_exam[i] <- T
               }
             }
           }
           text[!if_exam]
         })

lapply(target, writeLines)

path <- "~/code_backup/mcnebula2"
dir.create(path, recursive = T)

lapply(names(target),
       function(name){
         writeLines(target[[name]], paste0(path, "/", name))
       })

system("cp ~/code_backup/mcnebula2/* -t ~/MCnebula2/R")

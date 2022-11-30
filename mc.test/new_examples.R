setwd("~/MCnebula2/R")
library(magrittr)

script <- list.files(".", pattern = "\\.R$") %>% 
  sapply(readLines)

target <- 
  lapply(script,
         function(text){
           tar <- stringr::str_extract(text, "(?<=^#' @[a-z]{0,2}name ).{1,}(?=$)")
           tar <- unique(tar[!is.na(tar)])
         })

target

ex_path <- "/home/echo/outline/test/example/"
lapply(unique(unlist(target)),
       function(rd){
         path <- paste0(ex_path, rd, ".R")
         if (!file.exists(path))
           writeLines(c("", "## codes"), path)
       })



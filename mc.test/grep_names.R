setwd("~/MCnebula2/R")
library(magrittr)

script <- list.files(".", pattern = "\\.R$") %>% 
  sapply(readLines)

target <-
  lapply(script,
         function(text){
           lo_1 <- !grepl("@aliases|@exportClass|@family|new\\(", text)
           lo_2 <- grepl("^#'.*(?<![_|a-z|A-Z])nebula(?![-|_])", text, perl = T)
           lo <- lo_1 & lo_2
           text[lo] <- gsub("child(?!_)", "Child", text[lo], perl = T)
           text[lo] <- gsub("parent(?!_)", "Parent", text[lo], perl = T)
           text[lo] <- gsub("(?<![_|a-z|A-Z])nebula(?![-|_])", "Nebula",
                            text[lo], perl = T)
           text[lo] <- gsub("'Nebula'", "Nebula", text[lo])
           text[lo] <- gsub("'Nebulae'", "Nebulae", text[lo])
           text
         })

path <- "~/code_backup/mcnebula2"
dir.create(path, recursive = T)

lapply(names(target),
       function(name){
         writeLines(target[[name]], paste0(path, "/", name))
       })


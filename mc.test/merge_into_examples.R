setwd("~/MCnebula2/R")
library(magrittr)

script <- list.files(".", pattern = "\\.R$") %>% 
  sapply(readLines)

ex_path <- "/home/echo/outline/mc.test/example/"

dontrun <- function(codes){
  codes <- c("#' @examples",
             "#' \\dontrun{",
             paste0("#'   ", codes),
             "#' }"
  )
  paste0(codes, collapse = "\n")
}

target <- 
  lapply(script,
         function(text){
           sig <- 0
           record <- list()
           for (i in 1:length(text)) {
             if (!grepl("^#'", text[i])) {
               if (sig == 3) {
                 if (grepl("^[a-z|A-Z|.]", text[i])) {
                   if (!is.null(record[[tar]])) {
                     sig <- 1
                     next
                   }
                   record[[tar]] <- T
                   file <- paste0(ex_path, tar, ".R")
                   codes <- readLines(file)
                   start <- grep("^## codes", codes)[1] + 1
                   if (length(codes) < start) {
                     next
                   }
                   codes <- codes[start:length(codes)]
                   codes <- dontrun(codes)
                   if (!grepl("#'\\s{0,}$", text[i - 1])) {
                     codes <- paste0("#'\n", codes)
                   }
                   text[i] <- paste0(codes, "\n", text[i])
                 }
               }
               sig <- 1
               next
             }
             if (grepl("^#' @.{0,2}name", text[i])) {
               if (sig == 2) {
                 sig <- 3
                 tar <- stringr::str_extract(text[i], "(?<=^#' @[a-z]{0,2}name ).{1,}(?=$)")
               }
               next
             }
             if (grepl("^#' @param", text[i])) {
               sig <- 2
               next
             }
           }
           text
         })

lapply(target, writeLines)

path <- "~/code_backup/mcnebula2"
dir.create(path, recursive = T)

lapply(names(target),
       function(name){
         writeLines(target[[name]], paste0(path, "/", name))
       })

system("cp ~/code_backup/mcnebula2/* -t ~/MCnebula2/R")

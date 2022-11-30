#' ---
#' title: "Query GEO data of GSE136103"
#' output:
#'   pdf_document
#' ---

# /* path <- "~/operation/peng" */


#' ## Download GSE files

#' Download via 'ftp'. 

#+ eval = F, echo = T
gse <- "GSE136103"
gse.dir <- gsub("[0-9]{3}$", "nnn", gse)
ftp <- paste0("ftp://ftp.ncbi.nlm.nih.gov/geo/series/",
              gse.dir, "/", gse, "/suppl/")
system(paste("wget -np -m", ftp))

#' Decompress the file.

#+ eval = F, echo = T
## decompress
setwd("ftp.ncbi.nlm.nih.gov/geo/series/GSE136nnn/GSE136103/suppl")
dir.create("files")
system("tar -xf GSE136103_RAW.tar -C files")

#' ## Reformat files

#' Get metadata of these dataset.

#+ eval = F, echo = T
set <- list.files("files", pattern = "*.gz$")
metadata <- tibble::tibble(file = set)
metadata <-
  dplyr::mutate(metadata, path = paste0("files/", file),
                type = stringr::str_extract(file, "[^_]*$"),
                type = ifelse(type == "genes.tsv.gz", "features.tsv.gz", type),
                gsm = stringr::str_extract(file, "^[^_]*"),
                group = stringr::str_extract(file, "(?<=_).*(?=_)")
  )

#' Format these dataset for 'Seurat' Package to read.

#+ eval = F, echo = T
metadata_lst <- split(metadata, ~group)
dir.create("re.org")
mapply(metadata_lst, names(metadata_lst),
       FUN = function(df, name){
         lapply(paste0("re.org/", unique(df$group)), dir.create)
         apply(df, 1,
               function(vec){
                 dir <- paste0("re.org/", vec[["group"]])
                 file.copy(vec[[ "path" ]], paste0(dir, "/", vec[[ "type" ]]))
               })
       })

#' Use `Seurat::Read10X` to read these data.

#+ eval = F, echo = T
set <- sapply(list.files("re.org"), simplify = F,
              function(path){
                path <- paste0("re.org/", path)
                obj <- try(Seurat::Read10X(path), silent = T)
                if (inherits(obj, "try-error")) {
                  return("error")
                }
                Seurat::CreateSeuratObject(obj, min.cells = 3, min.features = 200)
              })

#' Some dataset caused 'error' while reading.

#+ eval = F, echo = T
de.error <- vapply(set, is.character, T)
reset <- set[!de.error]

#' The error dataset:

#+ eval = T, echo = T
de.error

#' Merge these dataset.

#+ eval = F, echo = T
merged <- merge(reset[[1]], reset[-1], 
                add.cell.ids = names(reset), merge.data = T)

#' Output as csv files

#+ eval = F, echo = T
all <- c(reset, all_merged = merged)
dir.create("reformat_table")
mapply(all, names(all),
       FUN = function(set, name){
         df <- dplyr::mutate(data.frame(set@assays$RNA@counts),
                             genes = rownames(set@assays$RNA@counts))
         df <- dplyr::relocate(df, genes)
         write.csv(df, paste0("reformat_table/", name, ".csv"),
                   row.names = F, col.names = T, quote = F)
       })


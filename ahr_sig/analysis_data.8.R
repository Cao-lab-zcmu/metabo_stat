## R
## meta
## ---------------------------------------------------------------------- 
## annotation
# gene.anno <- anno.gene.biomart("hsapiens_gene_ensembl", ex.attr = "go_id")
## ---------------------------------------------------------------------- 
## ---------------------------------------------------------------------- 
## ---------------------------------------------------------------------- 
gse <- meta$Accession[8]
set.sig.wd(gse)
## ------------------------------------- 
res.raw <- list.files(pattern = "Results.xlsx") %>% 
  readxl::read_xlsx()
## ------------------------------------- 
res.raw <- dplyr::select(res.raw, 1:4, contains(c("Log2FC", "pAdj")))
## ------------------------------------- 
res <- reshape2::melt(res.raw, id.vars = colnames(res.raw)[1:4],
                      variable.name = "type",
                      value.name = "value") %>% 
  dplyr::as_tibble() %>% 
  dplyr::mutate(contrast = gsub("_Log2FC|_pAdj", "", type),
                stat = stringr::str_extract(type, "(?<=_)[^_]{1,}$")) %>% 
  dplyr::select(-type) %>% 
  by_group_as_list("contrast")
## ------------------------------------- 
res <- lapply(res, tidyr::spread, key = stat, value = value)
## ------------------------------------- 
res <- lapply(res, dplyr::filter, abs(Log2FC) > 0.3, pAdj < 0.05)
## ------------------------------------- 
res <- lapply(res, dplyr::mutate, Ensembl = gsub("\\.[0-9]{1,}$", "", GeneID)) %>% 
  lapply(dplyr::relocate, Ensembl, ID)
## ------------------------------------- 
contrast <- names(res)[c(1, 2, 3, 4)]
res <- res[names(res) %in% contrast]
## ------------------------------------- 
## ========== Run block ========== 
mapply(res, names(res), 
       FUN = function(df, names){
         write_tsv(df, paste0(names, "_results.tsv"))
              })


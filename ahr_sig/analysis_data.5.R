## R
## meta
## ---------------------------------------------------------------------- 
## annotation
# attr <- list.attr.biomart()
# check <- 0
# n <- 0
# while(check == 0){
#   n <- n + 1
#   check <- try(gene.anno <- anno.gene.biomart("hsapiens_gene_ensembl", ex.attr = "go_id"),
#                silent = T)
#   if(class(check)[1] == "try-error"){
#     print(check)
#     check <- 0
#   }else{
#     check <- 1
#   }
#   cat("##", "Try...", n, "\n")
# }
# gene.anno <- anno.gene.biomart("hsapiens_gene_ensembl", ex.attr = "go_id")
## ---------------------------------------------------------------------- 
## ---------------------------------------------------------------------- 
## ---------------------------------------------------------------------- 
gse <- meta$Accession[5]
set.sig.wd(gse)
## unzip
list.files(pattern = "\\.gz") %>% 
  lapply(R.utils::gunzip)
## ------------------------------------- 
## ========== Run block ========== 
res <- data.table::fread("GSE188657_processed_data_files.txt") %>% 
  dplyr::filter(abs(log2FoldChange) > 0.3, qValue < 0.05) %>% 
  dplyr::as_tibble()
# treat.vs.contr:: AhR antagonist (StemRegenin 1) vs DMSO

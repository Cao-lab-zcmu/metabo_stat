## R
## meta
## ---------------------------------------------------------------------- 
## annotation
# gene.anno <- anno.gene.biomart("hsapiens_gene_ensembl", ex.attr = "go_id")
## ---------------------------------------------------------------------- 
## ---------------------------------------------------------------------- 
## ---------------------------------------------------------------------- 
gse <- meta$Accession[9]
set.sig.wd(gse)
## ------------------------------------- 
list.files(pattern = "\\.gz$") %>% 
  R.utils::gunzip()
## ------------------------------------- 
raw <- list.files(pattern = "\\.tab$") %>% 
  data.table::fread() %>% 
  dplyr::as_tibble()
## ------------------------------------- 
lapply(2:ncol(raw), function(ncol){
         file <- paste0(colnames(raw)[ncol], ".tsv")
         write_tsv(raw[, c(1, ncol)], file)
}) 
## ------------------------------------- 
meta.df <- data.table::data.table(
  file = list.files(pattern = "[0-9]\\.tsv$")
) %>% 
dplyr::mutate(
  sample = gsub("\\.tsv$", "", file),
  group = gsub("_[0-9]$", "", sample),
  group = gsub("-", "_", group)
)
## ------------------------------------- 
dge.list <- edgeR::readDGE(meta.df$file)
## group
dge.list <- re.sample.group(dge.list, meta.df)
## annotation
dge.list <- anno.into.list(dge.list, gene.anno, "ensembl_gene_id")
## ------------------------------------- 
group. <- dge.list$samples$group
## design
design <- model.matrix(~ 0 + group.)
## ------------------------------------- 
## contrast
contr.matrix <- limma::makeContrasts(
  treat_4.vs.contr = group.ahr_lna_4_6 - group.nc_lna_6,
  treat_7.vs.contr = group.ahr_lna_7_6 - group.nc_lna_6,
  levels = design
)
## ------------------------------------- 
res <- limma_downstream(dge.list, group., design, contr.matrix)
## ------------------------------------- 
## ========== Run block ========== 
mapply(res, paste0(names(res), "_results.tsv"), FUN = write_tsv)

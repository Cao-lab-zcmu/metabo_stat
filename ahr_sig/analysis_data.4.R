## R
## meta
## ---------------------------------------------------------------------- 
## annotation
# gene.anno <- anno.gene.biomart("hsapiens_gene_ensembl")
## ---------------------------------------------------------------------- 
## ---------------------------------------------------------------------- 
## ---------------------------------------------------------------------- 
gse <- meta$Accession[4]
set.sig.wd(gse)
## unzip
list.files(pattern = "\\.gz") %>% 
  lapply(R.utils::gunzip)
## ------------------------------------- 
## ========== Run block ========== 
df <- readxl::read_excel("GSE183606_differentially_expressed_genes.xlsx") %>% 
  ## rutaecarpin vs contral
  dplyr::filter(abs(`Log2FC(Rutaecar/Control)`) > 0.3, Padjust < 0.05)
write_tsv(df, "treat.vs.contr_results.tsv")


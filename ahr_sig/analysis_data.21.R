## R
## meta
## ---------------------------------------------------------------------- 
gse <- meta$Accession[21]
set.sig.wd(gse)
## ------------------------------------- 
meta.df <- decomp_tar2txt()
## ------------------------------------- 
meta.df <- dplyr::mutate(
  meta.df,
  sample = stringr::str_extract(file, "(?<=_).*(?=\\.count)"),
  sample = gsub("-", "_", sample),
  group = gsub("_[0-9]$", "", sample)
)
## ------------------------------------- 
# gene.anno <- anno.gene.biomart("hsapiens_gene_ensembl",
#                                attr = c("ensembl_gene_id", "hgnc_symbol", "refseq_mrna"))
## ------------------------------------- 
dge.list <- edgeR::readDGE(meta.df$file, columns = c(1, 2))
## add group
dge.list <- re.sample.group(dge.list, meta.df)
## add annotation
dge.list <- anno.into.list(dge.list, gene.anno, "hgnc_symbol")
## ------------------------------------- 
group. <- meta.df$group
design <- model.matrix(~ 0 + group.)
## ------------------------------------- 
## contrast
contr.matrix <- limma::makeContrasts(
  treat_d1.vs.control = group.TCDD_d1 - group.DMSO_d1,
  treat_d2.vs.control = group.TCDD_d2 - group.DMSO_d2,
  levels = design
)
## ------------------------------------- 
res <- limma_downstream(dge.list, group., design, contr.matrix)
## ------------------------------------- 
res <- lapply(res, dplyr::relocate, ensembl_gene_id, hgnc_symbol) %>% 
  lapply(dplyr::filter, !is.na(ensembl_gene_id))
## ------------------------------------- 
## ========== Run block ========== 
mapply(res, paste0(names(res), "_results.tsv"), FUN = write_tsv)


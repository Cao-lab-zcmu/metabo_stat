## R
## meta
## ---------------------------------------------------------------------- 
gse <- meta$Accession[18]
set.sig.wd(gse)
## ------------------------------------- 
list.files(pattern = "\\.gz$") %>% 
  R.utils::gunzip()
## ------------------------------------- 
## ========== Run block ========== 
raw <- data.table::fread("GSE130234_processed_data.txt") %>% 
  dplyr::as_tibble()
## ------------------------------------- 
mapply(2:ncol(raw), colnames(raw)[2:ncol(raw)],
       FUN = function(col, name){
         df <- raw[, c(1, col)]
         write_tsv(df, paste0(name, "_counts.tsv"))
       })
## ------------------------------------- 
meta.df <- data.table::data.table(
  file = list.files(pattern = "_counts.tsv$") 
) %>% 
  dplyr::mutate(sample = gsub("_tagcount_counts.tsv", "", file),
                sample = gsub("-", "_", sample),
                group = gsub("_rep.", "", sample))
## ------------------------------------- 
## annotation
gene.anno <- anno.gene.biomart("hsapiens_gene_ensembl",
                               attr = c("ensembl_gene_id", "hgnc_symbol", "refseq_mrna"))
## ------------------------------------- 
dge.list <- edgeR::readDGE(meta.df$file, columns = c(1, 2))
## add group
dge.list <- re.sample.group(dge.list, meta.df)
## add annotation
dge.list <- anno.into.list(dge.list, gene.anno, "refseq_mrna")
## ------------------------------------- 
# keeps <- !duplicated(dge.list$genes$ensembl_gene_id) | grepl("^NM_", dge.list$genes$refseq_mrna)
# ## filter...
# dge.list <- edgeR::`[.DGEList`(dge.list, keeps, , keep.lib.sizes = F)
## ------------------------------------- 
group. <- dge.list$samples$group
## design
design <- model.matrix(~ 0 + group.)
## contrast
contr.matrix <- limma::makeContrasts(
  treat_sga315.vs.contr = group.LOV_SGA315 - group.LOV,
  treat_sga360.vs.contr = group.LOV_SGA360 - group.LOV,
  levels = design
)
## ------------------------------------- 
res <- limma_downstream(dge.list, group., design, contr.matrix)
## ------------------------------------- 
## remove mRNA sequences of non-coding proteins
res <- lapply(res, dplyr::filter, !grepl("^NR_", refseq_mrna)) %>% 
  lapply(dplyr::relocate, ensembl_gene_id, hgnc_symbol) %>% 
  ## remove duplicated genes
  lapply(dplyr::distinct, ensembl_gene_id, .keep_all = T)
## ------------------------------------- 
## distribution
# exprs <- limma_downstream(dge.list, group., design, contr.matrix, get_normed.exprs = T)
## ------------------------------------- 
mapply(res, paste0(names(res), "_results.tsv"), FUN = write_tsv)


## R
## meta
## ---------------------------------------------------------------------- 
gse <- meta$Accession[20]
set.sig.wd(gse)
## ------------------------------------- 
list.files(pattern = "\\.gz$") %>% 
  R.utils::gunzip()
## ------------------------------------- 
raw <- data.table::fread("GSE104869_tablecounts.txt") %>% 
  dplyr::as_tibble()
## ------------------------------------- 
## remove the duplicated geneid
raw <- dplyr::mutate(raw, Geneid = gsub("\\.[0-9]$", "", Geneid)) %>% 
  dplyr::distinct(Geneid, .keep_all = T)
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
  dplyr::mutate(sample = gsub("_counts.tsv", "", file),
                sample = gsub(" ", "_", sample),
                sample = gsub("\\+", "_plus_", sample),
                group = gsub("[0-9]$", "", sample))
## ------------------------------------- 
gene.anno <- anno.gene.biomart("hsapiens_gene_ensembl",
                               attr = c("ensembl_gene_id", "hgnc_symbol", "refseq_mrna"))
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
  treat_R.vs.control = group.501Mel_R - group.501Mel_Ctrl,
  treat_T.vs.control = group.501Mel_T - group.501Mel_Ctrl,
  levels = design
)
## ------------------------------------- 
res <- limma_downstream(dge.list, group., design, contr.matrix)
## ------------------------------------- 
res <- lapply(res, dplyr::relocate, ensembl_gene_id, hgnc_symbol) %>% 
  lapply(dplyr::filter, !is.na(ensembl_gene_id))
## ------------------------------------- 
mapply(res, paste0(names(res), "_results.tsv"), FUN = write_tsv)

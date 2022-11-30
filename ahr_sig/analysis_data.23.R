## R
## meta
## ---------------------------------------------------------------------- 
gse <- meta$Accession[23]
set.sig.wd(gse)
## ------------------------------------- 
list.files(pattern = "\\.gz") %>% 
  lapply(R.utils::gunzip)
## ------------------------------------- 
raw <- data.table::fread("GSE116637_counts.txt") %>% 
  dplyr::mutate(Geneid = gsub("-[0-9]{1,}$", "", Geneid)) %>% 
  dplyr::distinct(Geneid, .keep_all = T) %>% 
  dplyr::as_tibble()
## ------------------------------------- 
lapply(7:ncol(raw), function(col){
         df <- raw[, c(1:6, col)]
         file <- colnames(raw)[col]
         write_tsv(df, paste0(file, "_counts.tsv"))
})
## ------------------------------------- 
meta.df <- data.table::data.table(
  file = list.files(pattern = "_counts.tsv$") 
) %>% 
  dplyr::mutate(sample = gsub("_counts.tsv", "", file),
                group = gsub("_[0-9]$", "", sample),
                cell = stringr::str_extract(group, "^[^_]{1,}"),
                agonist = stringr::str_extract(group, "[^_]{1,}$"))
cell.type <- meta.df$cell %>% 
  unique()
agonist.type <- meta.df$agonist %>% 
  unique()
## ------------------------------------- 
gene.anno <- anno.gene.biomart("hsapiens_gene_ensembl",
                               attr = c("ensembl_gene_id", "hgnc_symbol", "refseq_mrna"))
## ------------------------------------- 
dge.list <- edgeR::readDGE(meta.df$file, columns = c(1, 7))
## add group
dge.list <- re.sample.group(dge.list, meta.df)
## add annotation
dge.list <- anno.into.list(dge.list, gene.anno, "hgnc_symbol")
## ------------------------------------- 
group. <- meta.df$group
design <- model.matrix(~ 0 + group.)
## ------------------------------------- 
contr <- data.table::data.table(
  treat = c("3MC", "GNF"),
  control = "DMSO"
)
contr <- lapply(cell.type, function(cell){
                  dplyr::mutate(contr,
                    .treat = treat,
                    treat = paste0("group.", cell, "_", treat),
                    control = paste0("group.", cell, "_", control),
                    contr = paste0(treat, " - ", control),
                    name = paste0("treat_", cell, "_", .treat, ".vs.control"))
})
contr <- data.table::rbindlist(contr)
args <- lapply(contr$contr, function(text){
                 parse(text = text)
})
names(args) <- contr$name
args$levels <- design
## contrast matrix
contr.matrix <- do.call(limma::makeContrasts, args)
## ------------------------------------- 
res <- limma_downstream(dge.list, group., design, contr.matrix)
## ------------------------------------- 
## ========== Run block ========== 
res <- lapply(res, dplyr::relocate, ensembl_gene_id, hgnc_symbol) %>% 
  lapply(dplyr::filter, !is.na(ensembl_gene_id))
## save
mapply(res, paste0(names(res), "_results.tsv"), FUN = write_tsv)

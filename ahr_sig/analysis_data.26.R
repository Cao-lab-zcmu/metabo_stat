## R
## meta
## ---------------------------------------------------------------------- 
gse <- meta$Accession[26]
set.sig.wd(gse)
## ------------------------------------- 
meta.df <- decomp_tar2txt()
## ------------------------------------- 
raw <- lapply(meta.df$file, data.table::fread) 
## ------------------------------------- 
names(raw) <- meta.df$file
raw <- lapply(raw, dplyr::rename, symbol = 4, counts = 6) %>% 
  lapply(dplyr::relocate, symbol, counts) %>% 
  lapply(dplyr::distinct, symbol, .keep_all = T)
## save as tibble
mapply(raw, names(raw), FUN = function(df, file){
         write_tsv(df, file)
})
## ------------------------------------- 
## ========== Run block ========== 
meta.df <- dplyr::mutate(meta.df, 
                         sample = gsub("^GSM[0-9]{1,}_|_RPKM.txt", "", file),
                         group = gsub("^[0-9]{1,}-", "", sample),
                         group = gsub("-", "_", group),
                         .group = group,
                         block = stringr::str_extract(.group, "^[^_]{1,}"),
                         group = gsub("^[^_]{1,}", "AML", .group),
                         cell = stringr::str_extract(group, "^[^_]*(?=_)"),
                         agonist = stringr::str_extract(group, "(?<=_).*$"))
cell.type <- meta.df$cell %>% 
  unique()
agonist.type <- meta.df$agonist %>% 
  unique()
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
contr <- data.table::data.table(
  treat = agonist.type[3:length(agonist.type)],
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
contr <- data.table::rbindlist(contr) %>% 
  dplyr::filter(treat %in% colnames(design))
args <- lapply(contr$contr, function(text){
                 parse(text = text)
})
names(args) <- contr$name
args$levels <- design
## ------------------------------------- 
## contrast matrix
contr.matrix <- do.call(limma::makeContrasts, args)
## ------------------------------------- 
res <- limma_downstream(dge.list, group., design, contr.matrix, block = meta.df$block)
## ------------------------------------- 
res <- lapply(res, dplyr::relocate, ensembl_gene_id, hgnc_symbol) %>% 
  lapply(dplyr::filter, !is.na(ensembl_gene_id))
## save
mapply(res, paste0(names(res), "_results.tsv"), FUN = write_tsv)

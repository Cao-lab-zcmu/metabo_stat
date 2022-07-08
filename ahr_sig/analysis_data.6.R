## R
## meta
## ---------------------------------------------------------------------- 
## annotation
# gene.anno <- anno.gene.biomart("hsapiens_gene_ensembl", ex.attr = "go_id")
## ---------------------------------------------------------------------- 
## ---------------------------------------------------------------------- 
## ---------------------------------------------------------------------- 
gse <- meta$Accession[6]
set.sig.wd(gse)
## ------------------------------------- 
info <- GEOquery::getGEO(gse)
## ------------------------------------- 
info <- info[1]
get_gsm.data(info)
## ------------------------------------- 
list.files(pattern = ".tsv.gz$", recursive = T, full.names = T) %>% 
  sapply(function(path){
           system(paste("mv", path, "-t ."))
})
## ------------------------------------- 
list.files(pattern = ".tsv.gz$", recursive = T, full.names = T) %>% 
  sapply(R.utils::gunzip)
## ------------------------------------- 
## metadata
meta.df <- data.table::fread("metadata.csv", header = F) %>% 
  dplyr::rename(sample = 1, anno = 2) %>% 
  dplyr::mutate(group = ifelse(grepl("Untreated", anno), "control", "treatment"),
                time = stringr::str_extract(anno, "(?<=_)[0-9]{1,}(?=hr_)"),
                group = paste0(group, "_", time),
                file = paste0(sample, ".tsv"))
## ------------------------------------- 
## separate annotation
gsm.file <- list.files(pattern = "abundance.tsv$") %>% 
  sapply(function(file){
           df <- data.table::fread(file) %>% 
             dplyr::mutate(ensembl.v = stringr::str_extract(target_id,
                                                            "(?<=\\|)ENSG[0-9]{1,}[^\\|]{1,}(?=\\|)"),
                           ensembl = stringr::str_extract(ensembl.v, "^ENSG[0-9]{1,}")) %>% 
             dplyr::relocate(ensembl, tpm) %>% 
             dplyr::distinct(ensembl, .keep_all = T)
           file <- stringr::str_extract(file, "^GSM[0-9]{1,}(?=_)")
           write_tsv(df, paste0(file, ".tsv"))
           return(file)
})
## ------------------------------------- 
gene.anno.tmp <- data.table::fread(meta.df$file[1]) %>% 
  dplyr::select(ensembl, ensembl.v, eff_length)
## ------------------------------------- 
dge.list <- edgeR::readDGE(meta.df$file)
## add group
dge.list <- re.sample.group(dge.list, meta.df)
## add annotation
dge.list <- anno.into.list(dge.list, gene.anno, "ensembl_gene_id")
## log2 tpm
dge.list$counts <- apply(dge.list$counts, 2,
                         function(vec){
                           log2(vec + 1)
                         })
## ------------------------------------- 
group. <- dge.list$samples$group
## design
design <- model.matrix(~ 0 + group.)
## ------------------------------------- 
## contrast
contr.matrix <- limma::makeContrasts(
  treat.vs.contr_6 = group.treatment_6 - group.control_6,
  treat.vs.contr_18 = group.treatment_18 - group.control_18, 
  treat.vs.contr_72 = group.treatment_72 - group.control_72, 
  levels = design
)
## ------------------------------------- 
res <- limma_downstream(dge.list, group., design, contr.matrix,
                        min.count = 0.0001, voom = F)
## ------------------------------------- 
## ========== Run block ========== 
mapply(res, paste0(names(res), "_results.tsv"), FUN = write_tsv)


## R
## meta
## ---------------------------------------------------------------------- 
## annotation
# gene.anno <- anno.gene.biomart("hsapiens_gene_ensembl", ex.attr = c("ensembl_exon_id", "go_id"))
## ------------------------------------- 
check <- 0
n <- 0
while(check == 0){
  n <- n + 1
  check <- try(gene.anno <- anno.gene.biomart("hsapiens_gene_ensembl",
                                              ex.attr = c("go_id", "refseq_mrna")),
               silent = T)
  if(class(check)[1] == "try-error"){
    print(check)
    check <- 0
  }else{
    check <- 1
  }
  cat("##", "Try...", n, "\n")
}
## ---------------------------------------------------------------------- 
gse <- meta$Accession[17]
set.sig.wd(gse)
## ------------------------------------- 
meta.df <- decomp_tar2txt()
## ------------------------------------- 
meta.df <- dplyr::mutate(meta.df, sample = gsub("^GSM[^_]*_", "", file),
                         sample = gsub("\\.txt$", "", sample),
                         group = gsub("_60_S.*_pool.*$", "", sample))
## ------------------------------------- 
## format
raw <- lapply(meta.df$file, data.table::fread) %>% 
  lapply(dplyr::distinct, tracking_id, .keep_all = T) %>% 
  lapply(dplyr::rename, fpkm = 6) %>% 
  lapply(dplyr::mutate, fpkm = as.numeric(fpkm))
## filter NA
nas <- lapply(raw, dplyr::filter, is.na(fpkm)) %>% 
  lapply(`[[`, "tracking_id") %>% 
  unlist(use.names = F) %>% 
  unique()
raw <- lapply(raw, dplyr::filter, !tracking_id %in% all_of(nas))
## ------------------------------------- 
gene.anno.tmp <- dplyr::select(raw[[1]], 1:2)
## write into disk
mapply(write_tsv, raw, meta.df$file)
## ------------------------------------- 
dge.list <- edgeR::readDGE(meta.df$file, columns = c(1, 6))
## add group
dge.list <- re.sample.group(dge.list, meta.df)
## ------------------------------------- 
## add annotation
dge.list <- anno.into.list(dge.list, gene.anno.tmp, "tracking_id")
## ------------------------------------- 
dge.list <- fpkm_log2tpm(dge.list)
## ------------------------------------- 
group. <- dge.list$samples$group
## design
design <- model.matrix(~ 0 + group.)
## contrast
## ------------------------------------- 
contr.matrix <- limma::makeContrasts(
  treat_bap.vs.contr = group.MCF10AT1_BA_P - group.MCF10AT1_NT,
  treat_bpa.vs.contr = group.MCF10AT1_BPA - group.MCF10AT1_NT,
  treat_overlay.vs.contr = group.MCF10AT1_BPAplus_Ba_P - group.MCF10AT1_NT,
  levels = design
)
## ------------------------------------- 
res <- limma_downstream(dge.list, group., design, contr.matrix,
                        min.count = 0.0001, voom = F)
## ------------------------------------- 
## ========== Run block ========== 
mapply(res, paste0(names(res), "_results.tsv"), FUN = write_tsv)

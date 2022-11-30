## R
## meta
## ---------------------------------------------------------------------- 
## annotation
# gene.anno <- anno.gene.biomart("hsapiens_gene_ensembl", ex.attr = c("ensembl_exon_id", "go_id"))
## ------------------------------------- 
## ---------------------------------------------------------------------- 
gse <- meta$Accession[13]
set.sig.wd(gse)
## ------------------------------------- 
info <- GEOquery::getGEO(gse)
## ------------------------------------- 
meta.df.raw <- Biobase::phenoData(info[[1]]) %>%
  Biobase::pData() %>%
  dplyr::as_tibble()
## ------------------------------------- 
meta.df <- dplyr::select(meta.df.raw, title) %>% 
  dplyr::mutate(sample = title,
                group = gsub("_[0-9]{1,}$", "", sample),
                group = gsub("^.*U87_", "", group))
## ------------------------------------- 
group. <- meta.df$group
design <- model.matrix(~ 0 + group.)
## ------------------------------------- 
## contrast
contr.matrix <- limma::makeContrasts(
  ## treat with L-trp
#   il4i1_ahrKO.vs.ahrKO_1 = group.IL4I1_shAHR1 - group.C_shAHR1,
#   il4i1_ahrKO.vs.ahrKO_2 = group.IL4I1_shAHR2 - group.C_shAHR2,
  ahrKO_1.vs.control = group.C_shAHR1 - group.C_shC,
  ahrKO_2.vs.control = group.C_shAHR2 - group.C_shC,
  levels = design
)
## ------------------------------------- 
## show expression dataset
# exprs <- Biobase::assayData(info[[1]])$exprs 
## ------------------------------------- 
res <- limma_downstream.eset(info[[1]], design, contr.matrix) 
## ------------------------------------- 
res <- lapply(res, dplyr::mutate,
              ensembl = stringr::str_extract(gene_assignment, "ENS[A-Z][0-9]*"),
              symbol = stringr::str_extract(gene_assignment,
                "(?<= |^)[A-Z]{1,}[0-9]{0,2}[A-Z]{1,}[0-9]{0,2}[A-Z]{0,}[0-9]{0,3}(?= |$)")) %>% 
  lapply(dplyr::relocate, ensembl, symbol)
## ------------------------------------- 
## ========== Run block ========== 
mapply(res, paste0(names(res), "_results.tsv"), FUN = write_tsv)

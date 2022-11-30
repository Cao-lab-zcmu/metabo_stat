## R
## meta
## ---------------------------------------------------------------------- 
## annotation
# gene.anno <- anno.gene.biomart("hsapiens_gene_ensembl", ex.attr = c("ensembl_exon_id", "go_id"))
## ------------------------------------- 
## ---------------------------------------------------------------------- 
gse <- meta$Accession[10]
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
                group = gsub("U87_shC_", "", group))
## ------------------------------------- 
group. <- meta.df$group
design <- model.matrix(~ 0 + group.)
## contrast
contr.matrix <- limma::makeContrasts(
  treat_ficz.vs.contr = group.FICZ100nM - group.DMSO,
  treat_kyna.vs.contr = group.KynA50uM - group.DMSO, 
  levels = design
)
## ------------------------------------- 
## show expression dataset
# exprs <- Biobase::assayData(info[[1]])$exprs 
# print(head(exprs))
## ------------------------------------- 
# genes <- fit$genes %>% 
#   dplyr::as_tibble()
## ------------------------------------- 
res <- limma_downstream.eset(info[[1]], design, contr.matrix) 
## ------------------------------------- 
## ========== Run block ========== 
res <- lapply(res, dplyr::mutate,
              ensembl = stringr::str_extract(gene_assignment, "ENS[A-Z][0-9]*"),
              symbol = stringr::str_extract(gene_assignment,
                "(?<= |^)[A-Z]{1,}[0-9]{0,2}[A-Z]{1,}[0-9]{0,2}[A-Z]{0,}[0-9]{0,3}(?= |$)")) %>% 
  lapply(dplyr::relocate, ensembl, symbol)
## ------------------------------------- 
mapply(res, paste0(names(res), "_results.tsv"), FUN = write_tsv)

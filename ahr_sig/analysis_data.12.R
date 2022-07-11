## R
## meta
## ---------------------------------------------------------------------- 
## annotation
# gene.anno <- anno.gene.biomart("hsapiens_gene_ensembl", ex.attr = c("ensembl_exon_id", "go_id"))
## ------------------------------------- 
## ---------------------------------------------------------------------- 
gse <- meta$Accession[12]
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
  ## treat with CH223191
  treat_hpp.vs.contr = group.HPP40uM - group.DMSO,
  treat_i3p.vs.contr = group.I3P40uM - group.DMSO,
  treat_pp.vs.contr = group.PP40uM - group.DMSO,
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
                "(?<= |^)[A-Z]{1,}[0-9]{0,2}[A-Z]{1,}[0-9]{0,2}[A-Z]{0,}[0-9]{0,}(?= |$)")) %>% 
  lapply(dplyr::relocate, ensembl, symbol)
## ------------------------------------- 
mapply(res, paste0(names(res), "_results.tsv"), FUN = write_tsv)

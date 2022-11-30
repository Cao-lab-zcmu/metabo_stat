## R
## meta
## ---------------------------------------------------------------------- 
gse <- meta$Accession[19]
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
                group = gsub("^HepG2 ", "", sample),
                group = gsub(" ", "_", group))
## ------------------------------------- 
group. <- meta.df$group
design <- model.matrix(~ 0 + group.)
## ------------------------------------- 
## contrast
contr.matrix <- limma::makeContrasts(
  treat_mc3_1h.vs.control = group.MC3_1_h - group.NT,
  treat_mc3_24h.vs.control = group.MC3_24_h - group.NT,
  levels = design
)
## ------------------------------------- 
## show expression dataset
# exprs <- Biobase::assayData(info[[1]])$exprs 
## ------------------------------------- 
# res <- limma_downstream.eset(info[[1]], design, contr.matrix) 

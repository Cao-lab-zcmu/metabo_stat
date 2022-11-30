## R
## meta
## ---------------------------------------------------------------------- 
## annotation
# gene.anno <- anno.gene.biomart("hsapiens_gene_ensembl", ex.attr = c("ensembl_exon_id", "go_id"))
## ------------------------------------- 
## ---------------------------------------------------------------------- 
gse <- meta$Accession[16]
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
                group = gsub(" [0-9]{1,}$", "", sample),
                group = gsub("-", "_", group))
## ------------------------------------- 
group. <- meta.df$group
design <- model.matrix(~ 0 + group.)
## ------------------------------------- 
## contrast
contr.matrix <- limma::makeContrasts(
  treat.vs.control = group.Co_culture - group.Single_culture,
  levels = design
)
## ------------------------------------- 
## show expression dataset
# exprs <- Biobase::assayData(info[[1]])$exprs 
## ------------------------------------- 
res <- limma_downstream.eset(info[[1]], design, contr.matrix) 
## ------------------------------------- 
res <- lapply(res, dplyr::mutate,
              ensembl = stringr::str_extract(SPOT_ID.1, "ENS[A-Z][0-9]*"),
              symbol = stringr::str_extract(SPOT_ID.1,
                "(?<=\\()[A-Z]{1,}[0-9]{0,2}[A-Z]{1,}[0-9]{0,2}[A-Z]{0,}[0-9]{0,3}(?=\\))")) %>% 
  lapply(dplyr::relocate, ensembl, symbol)
## ------------------------------------- 
mapply(res, paste0(names(res), "_results.tsv"), FUN = write_tsv)

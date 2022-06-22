## R
## example in vignette of RNA-seq123
## the download data has been integrated as stat of counts
## if not, Rsubread packages would be used for integration
# url <- "https://www.ncbi.nlm.nih.gov/geo/download/?acc=GSE63310&format=file"
## download files 
# utils::download.file(url, destfile="GSE63310_RAW.tar", mode="wb") 
## ---------------------------------------------------------------------- 
## untar
# utils::untar("GSE63310_RAW.tar", exdir = ".")
## ------------------------------------- 
## select files
# file.gz <- list.files(pattern = "\\.gz$") %>% 
#   .[!grepl("CDBG|mo906111", .)]
## ------------------------------------- 
# file.gz %>% 
#   lapply(R.utils::gunzip)
## ------------------------------------- 
library(edgeR)
## ---------------------------------------------------------------------- 
## load data
## ---------------------------------------------------------------------- 
file <- list.files(pattern = "\\.txt$") %>% 
  .[!grepl("CDBG|mo906111", .)]
dge.list <- file %>% 
  ## the EntrezID and Count
  edgeR::readDGE(., columns = c(1, 3))
## ---------------------------------------------------------------------- 
## colnames of dge.list will renamed sample name globally
colnames(dge.list) <- colnames(dge.list) %>% 
  gsub("^[^_]{1,}_", "", ., perl = T)
## ------------------------------------- 
dge.list$samples <- dge.list$samples %>% 
  dplyr::mutate(group = as.factor(c("LP", "ML", "Basal", "Basal", "ML", "LP", 
                                    "Basal", "ML", "LP")),
                lane = as.factor(rep(c("L004","L006","L008"), c(3,4,2))))
## ---------------------------------------------------------------------- 
## ---------------------------------------------------------------------- 
## case biomaRt
# biomaRt::listEnsembl()
# ensembl <- biomaRt::useEnsembl(biomart = "genes")
## list all dataset
# datasets <- biomaRt::listDatasets(ensembl) %>% 
#   dplyr::as_tibble()
## search
## ------------------------------------- 
# hsa <- biomaRt::useDataset(dataset = "hsapiens_gene_ensembl", mart = ensembl)
## biomaRt::getBM(..., mart = hsa)
## biomaRt::listAttributes(mart = hsa)
## ---------------------------------------------------------------------- 
## gene annotation
## ---------------------------------------------------------------------- 
AnnotationDbi::columns(Mus.musculus::Mus.musculus)
## ---------------------------------------------------------------------- 
genes <- AnnotationDbi::select(Mus.musculus::Mus.musculus,
                               keys = rownames(dge.list),
                               columns = c("SYMBOL", "TXCHROM"), 
                               keytype = "ENTREZID")
genes <- dplyr::distinct(genes, ENTREZID, .keep_all = T)
## ------------------------------------- 
dge.list$genes <- genes
## ---------------------------------------------------------------------- 
## scale
## ---------------------------------------------------------------------- 
## a tibble
# cpm <- edgeR::cpm(dge.list) %>% 
#   data.frame() %>% 
#   dplyr::mutate(., Tags = rownames(.)) %>% 
#   dplyr::as_tibble() %>% 
#   dplyr::relocate(Tags)
# ## ------------------------------------- 
# lcpm <- edgeR::cpm(dge.list, log = T, prior.count = 2)
# summary(lcpm)
## ---------------------------------------------------------------------- 
## filter
## ---------------------------------------------------------------------- 
## the keeped gene
keep.exprs <- edgeR::filterByExpr(dge.list, group = dge.list$samples$group)
## filter gene
dge.list[keep.exprs,, keep.lib.sizes = F]
## ---------------------------------------------------------------------- 
## normalization
## ---------------------------------------------------------------------- 
dge.list <- calcNormFactors(dge.list, method = "TMM")
## ---------------------------------------------------------------------- 
## model.matrix
## ---------------------------------------------------------------------- 
design <- model.matrix(~ 0 + dge.list$samples$group + dge.list$samples$lane)
## rename
colnames(design) <- colnames(design) %>% 
  extra::mapply_rename_col(c("dge.list$samples$group", "dge.list$samples$"),
                           c("", ""), name = ., fixed = T)
## ---------------------------------------------------------------------- 
## make contrast
## ---------------------------------------------------------------------- 
contr.matrix <- limma::makeContrasts(
  Basal.LP = Basal - LP,
  Basal.ML = Basal - ML,
  LP.ML = LP - ML,
  levels = design
)
## ---------------------------------------------------------------------- 
## linear fit
## ---------------------------------------------------------------------- 
## voom.dge.list$E == log-CPM
voom <- limma::voom(dge.list, design)
## linear fit
fit <- limma::lmFit(voom, design)
## add contrasts matrix
fit.cont <- limma::contrasts.fit(fit, contrasts = contr.matrix)
## p_value and q-value
ebayes <- limma::eBayes(fit.cont)
## fdr
fdr.ebayes <- limma::decideTests(ebayes)
## show summary
show <- summary(fdr.ebayes)
## top genes
# topTable(ebayes)
## ---------------------------------------------------------------------- 
## add logFC to rank
## ---------------------------------------------------------------------- 
## ========== Run block ========== 
fc_treat <- limma::treat(fit.cont, lfc = 1)
## fdr adjust
fdr.fc_treat <- limma::decideTests(fc_treat)
## list all results
## this also add gene annotation into dataframe
basal.vs.ml <- limma::topTreat(fc_treat, coef = 2, n = Inf) %>% 
  dplyr::as_tibble()


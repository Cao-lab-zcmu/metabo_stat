# ==========================================================================
# download and check dataset of GSE223325
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

`%>%` <- magrittr::`%>%`

gse <- "GSE223325"
about <- GEOquery::getGEO(gse)
about[[1]]$data_processing.3[1]

gpl <- about[[1]]@annotation
anno <- GEOquery::getGEO(gpl)
org <- anno@header$organism

GEOquery::getGEOSuppFiles(gse)
utils::untar(list.files(gse, full.names = T), exdir = gse)
lapply(list.files(gse, "\\.gz$", full.names = T), R.utils::gunzip)

metadata <- data.frame(files = list.files(gse, "\\.txt$", full.names = T)) %>% 
  dplyr::mutate(group = ifelse(grepl("M1\\.txt", files), "M1", "M2"),
  group.anno = ifelse(group == "M1", "LPC + IFN", "IL-4"),
  sample = gsub("^.*/|\\.txt$", "", files))

tibble::as_tibble(data.table::fread("./GSE223325/GSM6945621_RA1M1.txt"))

# ==========================================================================
# use 'limma' for difference analysis
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

dge.list <- edgeR::readDGE(metadata$files, columns = c(1, 2))
dge.list <- re.sample.group(dge.list, metadata)

# use `biomaRt::useEnsembl`
gene.anno <- anno.gene.biomart("hsapiens_gene_ensembl")
dge.list <- anno.into.list(dge.list, gene.anno, "ensembl_gene_id")

group. <- dge.list$samples$group
design <- model.matrix(~ 0 + group.)
contr.matrix <- limma::makeContrasts(
  M1_vs_M2 = group.M1 - group.M2,
  levels = design
)

keep.exprs <- edgeR::filterByExpr(dge.list, group = group., min.count = 10)
dge.list <- edgeR::`[.DGEList`(dge.list, keep.exprs, , keep.lib.sizes = F)

dge.list <- edgeR::calcNormFactors(dge.list, method = "TMM")
dge.list <- limma::voom(dge.list, design)

fit <- limma::lmFit(dge.list, design)
fit.cont <- limma::contrasts.fit(fit, contrasts = contr.matrix)
ebayes <- limma::eBayes(fit.cont)

res <- limma::topTable(ebayes, coef = 1, number = Inf)
res <- tibble::as_tibble(res)
res.tops <- dplyr::filter(res, adj.P.Val < .05, abs(logFC) > 1)
res.top30 <- head(res.tops, n = 30)

# ==========================================================================
# use 'clusterProfiler' for enrichment analysis
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# remotes::install_github("YuLab-SMU/clusterProfiler")

ids <- clusterProfiler::bitr(
  res.top30$ensembl_gene_id, "ENSEMBL",
  "ENTREZID", "org.Hs.eg.db", F
)
ids <- dplyr::distinct(ids, ENSEMBL, .keep_all = T)

res.top30.ex <- dplyr::mutate(res.top30, entrezid = ids[[2]]) %>% 
  dplyr::filter(!is.na(entrezid))

res.kegg <- clusterProfiler::enrichKEGG(res.top30.ex$entrezid)

gene.data <- res.top30.ex$logFC / max(abs(res.top30.ex$logFC))
names(gene.data) <- res.top30.ex$entrezid
pathways <- gsub("^[a-z]*", "", res.kegg@result$ID)

data(bods, package = "pathview")
res.pathv <- sapply(pathways, simplify = F,
  function(id) {
    pathview::pathview(gene.data, pathway.id = id, species = "hsa")
  })



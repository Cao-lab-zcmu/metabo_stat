## R
## meta
## ---------------------------------------------------------------------- 
## annotation
gene.anno <- anno.gene.biomart("hsapiens_gene_ensembl")
## ---------------------------------------------------------------------- 
## ---------------------------------------------------------------------- 
## ---------------------------------------------------------------------- 
gse <- meta$Accession[3]
set.sig.wd(gse)
# meta.df <- decomp_tar2txt()
## get infoma...
info <- GEOquery::getGEO(gse)
## ------------------------------------- 
## download data respectively
get_gsm.data(info)
## ------------------------------------- 
# control (scramble) siRNA + DMSO (GSM5579231, GSM5579232) vs 
# control (scramble) siRNA + TCDD (GSM5579233)
meta.df <- data.table::data.table(
  file.xlsx = list.files(pattern = "^GSM557923[1-3]{1}_.*\\.xlsx")
) %>% 
  dplyr::mutate(group = rep(c("control", "treatment"), c(2, 1)),
                file = gsub("\\.xlsx$", ".txt", file.xlsx),
                sample = c("control_1", "control_2", "treat"))
## ------------------------------------- 
## format data
mapply(meta.df$file.xlsx, meta.df$file,
       FUN = function(xlsx, txt){
         df <- readxl::read_xlsx(xlsx) %>% 
           dplyr::relocate(ENSEMBL, `Total exon reads`)
         write_tsv(df, txt)
       })
## ------------------------------------- 
gene.anno.tmp <- data.table::fread(meta.df$file[1]) %>% 
  dplyr::select(ENSEMBL, Name, Chromosome, `Exon length`)
## ------------------------------------- 
dge.list <- edgeR::readDGE(meta.df$file)
## group
dge.list <- re.sample.group(dge.list, meta.df)
## annotation
dge.list <- anno.into.list(dge.list, gene.anno.tmp, "ENSEMBL")
## ------------------------------------- 
group. <- dge.list$samples$group
## design
design <- model.matrix(~ 0 + group.)
## contrast
contr.matrix <- limma::makeContrasts(
  treat.vs.contr = group.treatment - group.control,
  levels = design
)
## ------------------------------------- 
res <- limma_downstream(dge.list, group., design, contr.matrix)
## save
mapply(res, paste0(names(res), "_results.tsv"), FUN = write_tsv)


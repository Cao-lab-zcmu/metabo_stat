## R
## meta
## ---------------------------------------------------------------------- 
## annotation
# gene.anno <- anno.gene.biomart("hsapiens_gene_ensembl")
## ---------------------------------------------------------------------- 
## ---------------------------------------------------------------------- 
## ---------------------------------------------------------------------- 
gse <- meta$Accession[1]
set.sig.wd(gse)
meta.df <- decomp_tar2txt()
## ------------------------------------- 
meta.df <- dplyr::mutate(
  meta.df, 
  treatment = stringr::str_extract(
    file, "(?<=D7-).*(?=_RNA-seq)"
    ),
  group = treatment,
  sample = stringr::str_extract(
    file, "(?<=_).*(?=_RNA-seq)"
  )
)
## ------------------------------------- 
gene.anno.tmp <- data.table::fread(meta.df$file[1]) %>% 
  dplyr::select(grep("Symbol|Ensembl|reference sequence", colnames(.))) %>% 
  dplyr::mutate(ref = `Locus on reference sequence`,
                chr = stringr::str_extract(ref, "^chr[0-9]{1,}(?=:)"),
                seq.st = stringr::str_extract(ref, "(?<=:)[0-9]{1,}(?=-)"),
                seq.st = as.integer(seq.st),
                seq.end = stringr::str_extract(ref, "(?<=-)[0-9]{1,}$"),
                seq.end = as.integer(seq.end),
                eff.len = abs(seq.st - seq.end)) %>% 
  dplyr::relocate(`Ensembl Gene ID`, `eff.len`) %>% 
  dplyr::as_tibble()
## ------------------------------------- 
dge.list <- edgeR::readDGE(meta.df$file, columns = c(12, 2))
## add group
dge.list <- re.sample.group(dge.list, meta.df)
## add annotation
dge.list <- anno.into.list(dge.list, gene.anno.tmp, "Ensembl Gene ID")
## ------------------------------------- 
## fpkm to tpm
dge.list <- fpkm_log2tpm(dge.list)
## ------------------------------------- 
group. <- dge.list$samples$group
## design
design <- model.matrix(~ 0 + group.)
## contrast
contr.matrix <- limma::makeContrasts(
  ## treat with CH223191
  treat_ch.vs.contr = group.CH - group.C,
  ## treat with StemRegenin1
  treat_sr.vs.contr = group.SR1 - group.C, 
  levels = design
)
## ------------------------------------- 
## ========== Run block ========== 
res <- limma_downstream(dge.list, group., design, contr.matrix,
                        min.count = 0.0001, voom = F)
## ------------------------------------- 
## save
mapply(res, paste0(names(res), "_results.tsv"), FUN = write_tsv)

## R
## gather analysis results
setwd("~/operation/geo_db/ahr_sig/")
## ------------------------------------- 
all_results <- list.files(pattern = "_results.tsv",
                          recursive = T, 
                          full.names = T) %>% 
  data.frame() %>% 
  dplyr::rename(file = 1) %>% 
  dplyr::mutate(filename = stringr::str_extract(file, "[^/]*$"),
                contrast = stringr::str_extract(filename, "^.*(?=_results)"),
                series = stringr::str_extract(file, "(?<=/)GSE[0-9]{1,}(?=/)"))
## ---------------------------------------------------------------------- 
## cell, treat.left, treat.right
all_series <- all_results$series %>% 
  unique()
## ---------------------------------------------------------------------- 
lst.sum <- lapply(all_series, function(gse){
                    info <- try_do("GEOquery::getGEO(gse)", envir = environment())
                    info <- lapply(info,
                                   function(obj){
                                     obj <- Biobase::experimentData(obj)
                                     obj@other$summary
                                   })
                })
names(lst.sum) <- all_series
## ---------------------------------------------------------------------- 
lst.sum <- lapply(lst.sum, `[`, 1) %>% 
  data.table::data.table() %>% 
  dplyr::rename(summary = 1) %>% 
  dplyr::mutate(Accession = all_series, summary = unlist(summary)) %>% 
  dplyr::as_tibble()
## ---------------------------------------------------------------------- 
meta.summary <- merge(meta, lst.sum, by = "Accession", all.y = T) %>% 
  dplyr::as_tibble()
write_tsv(meta.summary, "meta.summary.tsv")
## ---------------------------------------------------------------------- 
gene.anno <- anno.gene.biomart("hsapiens_gene_ensembl",
                               attr = c("ensembl_gene_id", "hgnc_symbol"))
## ---------------------------------------------------------------------- 
screened.genes <- lapply(all_results$file, data.table::fread) %>% 
  lapply(function(df){
           df <- df %>% 
             dplyr::rename(ensembl = 1, symbol = 2)
           ## if number > n, filter out the rest
           n <- 1000
           if(nrow(df) > n){
             ## col of adjust p.value
             adj.p <- colnames(df) %>% 
               .[grepl("adj|q-value", ., ignore.case = T)]
             df <- dplyr::rename(df, adj.p = paste0(adj.p)) %>% 
               dplyr::arrange(adj.p) %>% 
               ## get top n
               head(n = n) %>% 
               dplyr::relocate(ensembl, symbol)
           }
           df <- dplyr::select(df, 1:2)
           return(df)
                }) %>% 
  data.table::rbindlist() %>% 
  dplyr::filter(!is.na(ensembl) & !is.na(symbol) & symbol != "") %>% 
  dplyr::filter(ensembl %in% all_of(gene.anno$ensembl_gene_id)) %>% 
  # dplyr::mutate(symbol = gsub("\\.[0-9]$", "", symbol)) %>% 
  dplyr::distinct() %>% 
  dplyr::as_tibble()
## ---------------------------------------------------------------------- 
## AHR targets were retrieved from the Transcription Factor Target Gene Database
## <http://tfbsdb.systemsbiology.net/>
tf.db <- data.table::fread("TFTGD_ahr_targes.tsv") %>% 
  dplyr::mutate(symbol = ifelse(grepl("^V_", Motif),
                                stringr::str_extract(Motif, "(?<=^V_)[^_]{1,}"),
                                stringr::str_extract(Motif, "^[^_]{1,}"))) %>% 
  dplyr::distinct(symbol) 
## ------------------------------------- 
tf.db <- dplyr::filter(gene.anno, hgnc_symbol %in% all_of(tf.db$symbol)) %>% 
  dplyr::select(ensembl_gene_id, hgnc_symbol) %>% 
  distinct() %>% 
  dplyr::rename(ensembl = 1, symbol = 2)
## ---------------------------------------------------------------------- 
## ========== Run block ========== 
## merge genes from 'screened.genes' and 'tf.db'
merge.scre_tf <- dplyr::bind_rows(screened.genes, tf.db) %>% 
  dplyr::distinct()
write_tsv(merge.scre_tf, "merge.scre_tf.tsv")
## ---------------------------------------------------------------------- 

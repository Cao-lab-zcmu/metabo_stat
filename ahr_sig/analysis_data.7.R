## R
## meta
## ---------------------------------------------------------------------- 
## annotation
# gene.anno <- anno.gene.biomart("hsapiens_gene_ensembl", ex.attr = "go_id")
## ---------------------------------------------------------------------- 
## ---------------------------------------------------------------------- 
## ---------------------------------------------------------------------- 
gse <- meta$Accession[7]
set.sig.wd(gse)
## ------------------------------------- 
list.files(pattern = "txt\\.gz$", recursive = T, full.names = T) %>% 
  sapply(R.utils::gunzip)
## ------------------------------------- 
raw.res <- list.files(pattern = "processed") %>% 
  lapply(data.table::fread) %>% 
  lapply(function(df){
           df[1:2, ]
}) 
## ------------------------------------- 
raw.res <- lapply(raw.res, function(df){
                    mutate.df <- data.table::data.table(
                      ncol = 1:ncol(df),
                      contrast = unlist(df[1, ], use.names = F),
                      type = unlist(df[2, ], use.names = F)
                    )
                    return(mutate.df)
})
## ------------------------------------- 
form.res <- lapply(raw.res, function(df){
                     dplyr::filter(df, contrast == "" | grepl(" vs ", contrast))
}) %>% 
  lapply(by_group_as_list, colnames = "contrast")
## the annotation col
ex.anno.cal <- form.res[[1]][[1]]
## contrast col
form.res <- lapply(form.res, function(lst){
                     lst[[1]] <- NULL
                     lst
})
## ------------------------------------- 
raw.res <- list.files(pattern = "processed") %>% 
  lapply(data.table::fread, skip = 2, header = F) 
## ------------------------------------- 
res <- mapply(form.res, raw.res,
              SIMPLIFY = F,
              FUN = function(form, raw){
                ## convert data.table to tibble
                raw <- dplyr::as_tibble(raw)
                lst <- lapply(form, raw = raw,
                              FUN = function(entry, raw){
                                col <- c(1:4, entry$ncol)
                                ## colnames of data.frame
                                col.name <- c(ex.anno.cal$type, "log2FC", "p-value", "q-value")
                                ## extract column
                                df <- raw[, col]
                                colnames(df) <- col.name
                                ## filter data
                                df <- dplyr::filter(df, abs(log2FC) > 0.3, `q-value` < 0.05)
                                return(df)
                    })
              })
## ------------------------------------- 
res <- unlist(res, recursive = F)
## ------------------------------------- 
contrast.entry <- names(res)
contrast <- contrast.entry[c(3, 8, 9, 10)]
res <- res[names(res) %in% contrast]
## ------------------------------------- 
## ========== Run block ========== 
mapply(res, names(res), 
       FUN = function(df, names){
         write_tsv(df, paste0(names, "_results.tsv"))
              })


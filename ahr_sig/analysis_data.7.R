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
## ========== Run block ========== 
res <- mapply(form.res, raw.res,
              SIMPLIFY = F,
              FUN = function(form, raw){

              })

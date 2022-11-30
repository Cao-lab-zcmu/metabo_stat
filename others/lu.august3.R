## R
# path <- "~/operation/lu/"
## the file
## ------------------------------------- 
file <- "protein.tsv"
df <- data.table::fread(file) %>% 
  dplyr::as_tibble()
## ------------------------------------- 
anno <- dplyr::select(df, id, description, R2, Slope) %>% 
  dplyr::distinct(id, .keep_all = T)
## ------------------------------------- 
data <- by_group_as_list(df, "condition")
fdata.list <- mapply(data, names(data), SIMPLIFY = F,
                FUN = function(df, temp){
                  col <- colnames(df) %>% 
                    grep("^[0-9]", .)
                  temp <- paste0("temp", temp)
                  colnames(df)[col] <- paste0(temp, "_", colnames(df)[col])
                  df <- dplyr::select(df, id, contains("temp"))
                  return(df)
                })
## ---------------------------------------------------------------------- 
## ---------------------------------------------------------------------- 
## ---------------------------------------------------------------------- 
fdata <- dplyr::select(df, id) %>% 
  dplyr::distinct()
## merge
for(i in 1:length(fdata.list)){
  fdata <- merge(fdata, fdata.list[[i]], by = "id", all.x = T, sort = F)
}
fdata <- dplyr::select(fdata, -1) %>% 
  apply(1, function(vec){
          vec <- ifelse(is.na(vec), 1, vec)
          vec <- vec / (max(vec) * 1.01)
                }) %>% 
  t() %>% 
  as.matrix() 
rownames(fdata) <- anno$id
## ------------------------------------- 
metadata <- colnames(fdata) %>%
  .[grepl("^temp", .)] %>%
  get_metadata_from_names(
    meta.group = c(temp37 = "^temp37", temp52 = "^temp52", temp59 = "^temp59")
  ) %>% 
  dplyr::mutate(conc. = stringr::str_extract(sample, "[^_]{1,}$"),
                conc. = as.numeric(conc.))
## ---------------------------------------------------------------------- 
## ---------------------------------------------------------------------- 
## ---------------------------------------------------------------------- 
## design matrix
group. <- metadata$group
conc. <- metadata$conc.
## ln[Y/(1−Y)] = a + bx
design <- model.matrix(~ 0 + group. + group.:conc.)
## ------------------------------------- 
re.fdata <- log( fdata / (1 - fdata) )
fit <- limma::lmFit(re.fdata, design = design)
fit$genes <- anno
fit <- limma::eBayes(fit)
## ------------------------------------- 
coef.group <- colnames(fit$coefficients) %>% 
  stringr::str_extract("^[^:]{1,}")
coef.group <- data.table::data.table(
  coef = coef.group,
  col = 1:length(coef.group)
) %>% 
  by_group_as_list("coef") 
results <- coef.group %>% 
  lapply(function(coef.df){
           df <- limma::topTable(fit, coef = coef.df$col, number = Inf)
           dplyr::as_tibble(df)
})
## ------------------------------------- 
mapply(results, names(results),
       FUN = function(df, name){
         openxlsx::write.xlsx(df, paste0(name, ".xlsx"))
       })
## ---------------------------------------------------------------------- 
## ---------------------------------------------------------------------- 
## ---------------------------------------------------------------------- 
## ========== Run block ========== 
## check results
concentration <- unique(conc.)
## y = exp(a + bx) / ( 1 + exp(a + bx) )
map_list <- results %>% 
  lapply(function(df){
           df <- dplyr::select(df, contains("group.")) %>% 
             dplyr::slice(1:50) %>% 
             apply(1, simplify = F,
                   function(vec){
                     df <- data.frame(x = concentration) %>% 
                       dplyr::mutate(y = vec[[1]] + vec[[2]] * x,
                                     y = exp(y) / (1 + exp(y)))
                   }) %>% 
             data.table::rbindlist(idcol = T) %>% 
             dplyr::rename(rank = .id)
       })
## ------------------------------------- 
## plot the line
get_facet_line <- 
  function(
           df
           ){
    p <- ggplot(df, aes(x = x, y = y)) +
      geom_line() +
      facet_wrap(~ rank)
  }
## ------------------------------------- 
## ========== Run block ========== 
p <- get_facet_line(map_list[[1]])
## ------------------------------------- 
## ---------------------------------------------------------------------- 
## ---------------------------------------------------------------------- 
## ---------------------------------------------------------------------- 
# ## check raw
# top50 <- lapply(results, function(df){
#                   dplyr::slice(df, 1:50)$id
#            })
# ## ------------------------------------- 
# ## temp37
# top50_raw <- fdata.list[[1]] %>% 
#   dplyr::filter(id %in% all_of(top50[[1]])) %>% 
#   dplyr::mutate(id = factor(id, levels = top50[[1]])) %>% 
#   dplyr::arrange(id) %>%
#   reshape2::melt(id.vars = "id", value.name = "value", variable.name = "con") %>% 
#   dplyr::mutate(x = stringr::str_extract(con, "[^_]{1,}$"),
#                 x = as.numeric(x),
#                 y = value,
#                 rank = id)
# ## ------------------------------------- 
# p_raw <- get_facet_line(top50_raw)

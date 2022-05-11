## ------------------------------------- 
## ------------------------------------- 
## sub_stat
## ------------------------------------- 
## ------------------------------------- 
## stat sub-structural classification
## which possiboly be sub-structural classification
sub_stat <- dplyr::filter(stat, false >= 0.4)
sub_stat_list <- stat_list[which(names(stat_list) %in% sub_stat$"classification")]
sub_stat_list <- lapply(sub_stat_list, dplyr::select, id)
df <- dplyr::select(meta, .id, SMILES)
## merge smiles into list
sub_stat_list <- pbapply::pblapply(sub_stat_list, merge,
                        y = df, by.x = "id", by.y = ".id",
                        all.x = T)
## ------------------ 
## get prepared pattern set
file_set <- list.files("~/extra/data", full.names = T)
pattern_set <- lapply(file_set, function(x){
                        dplyr::slice(read_txt(x), 1)
                        })
names(pattern_set) <- stringr::str_extract(file_set, "(?<=data/).*$")
## ------------------ 
## order list to keep names of two list in line
pattern_set <- order_list(pattern_set)
sub_stat_list <- order_list(sub_stat_list)
sub_test <- mapply(struc_match_in_df,
                   sub_stat_list,
                   unlist(pattern_set),
                   SIMPLIFY = F)
## ------------------
## results
stat_sub_test <- lapply(sub_test, table_app) %>%
  data.table::rbindlist(idcol = T, fill = T) %>%
  dplyr::rename(classification = .id)
## ------------------ 
## conclusion
# stat
# dominant_stat
# stat_sub_test


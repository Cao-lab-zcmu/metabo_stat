## ---------------------------------------------------------------------- 
## reformat peak list and upload to metDNA
metdna_feature <- feature_csv %>%
  dplyr::select(contains("ID"), contains("m/z"), contains("retention"), contains("Peak area"))
## rename as metDNA recogonized name
colnames(metdna_feature) <- colnames(metdna_feature) %>% 
  ## find and sort as order of `key`
  .meta_find_and_sort(., c("ID", "m/z", "retention")) %>% 
  ## rename columns of df_mz_rt
  mapply_rename_col(., c("name", "mz", "rt"), colnames(metdna_feature)) %>% 
  ## remove ` Peak area`
  gsub(" Peak area", "", .)
## ------------------------------------- 
metdna_feature <- metdna_feature %>% 
  dplyr::mutate(rt = 60 * rt)
## ------------------------------------- 
write.csv(metdna_feature, file = "metdna_feature.csv", row.names = F, quote = F)
## ---------------------------------------------------------------------- 
## reformat 
metdna_metadata <- metadata %>% 
  dplyr::select(sample, group) %>% 
  dplyr::rename(sample.name = sample)
## ------------------------------------- 
write.csv(metdna_metadata, file = "metdna_metadata.csv", row.names = F, quote = F)
## ---------------------------------------------------------------------- 

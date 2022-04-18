## for pie diagram plot in child nebula,
## herein, the feature abundance data were
## collated 
## ------------------------------------- 
feature_stat <- colnames(origin_analysis) %>% 
  ## pattern match cols
  grep("origin_id|[A-Z]{2}[0-9]{1,2}", .) %>% 
  dplyr::select(origin_analysis, .)
## ------------------------------------- 
## set metadata of feature_stat
meta_feature_stat <- colnames(feature_stat)[-1] %>% 
  data.table::data.table(name = .) %>% 
  dplyr::mutate(subgroup = stringr::str_extract(name, "^[A-Z]{2}"),
                subgroup_name = unlist(lapply(subgroup, switch,
                                              NN = "non-hospital & non-infected",
                                              HN = "hospital & non-infected",
                                              HS = "hospital & survival",
                                              HM = "hospital & mortality")),
                ## group name
                group = unlist(lapply(subgroup, switch,
                                      NN = "control groups",
                                      HN = "control groups",
                                      HS = "infection groups",
                                      HM = "infection groups")))
## simplify
simp.group <- dplyr::select(meta_feature_stat, name, subgroup)
## ---------------------------------------------------------------------- 
## summarise mean of each .id in groups
mean.feature_stat <- feature_stat %>% 
  ## as long table
  reshape2::melt(id.vars = "origin_id", variable.name = "name", value.name = "value") %>%
  ## get group info
  merge(simp.group, by = "name", all.x = T) %>% 
  data.table::data.table() %>% 
  ## as numeric
  dplyr::mutate(value = as.numeric(value)) %>% 
  ## group by origin_id and subgroup
  .[, list(mean = mean(value, na.rm = T)), by = list(origin_id, subgroup)] %>% 
  ## calculate mean
  dplyr::mutate(mean = ifelse(is.nan(mean), 0, mean)) %>% 
  ## as wide data
  data.table::dcast(origin_id ~ subgroup, value.var = "mean") %>% 
  dplyr::as_tibble()
## ---------------------------------------------------------------------- 

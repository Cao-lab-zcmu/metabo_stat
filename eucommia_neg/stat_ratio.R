## stat peak area
mzmine_table <- "mcnebula_results/mzmine_table.tsv" %>% 
  read_tsv()
## ------------------------------------- 
mz_rt <- mzmine_table %>% 
  dplyr::select(1:3) %>% 
  dplyr::rename(.id = 1, mz = 2, rt = 3) %>% 
  dplyr::mutate(.id = as.character(.id))
## ------------------------------------- 
## reset name
colnames(mzmine_table) <- gsub("\\.mzML Peak area", "", colnames(mzmine_table))
## metadata
meta_feature_stat <- colnames(mzmine_table)[c(-1, -2, -3)] %>% 
  data.table::data.table(name = .) %>% 
  dplyr::mutate(subgroup = stringr::str_extract(name, ".*(?=[0-9])"),
                subgroup = ifelse(is.na(subgroup), "Blank", subgroup))
## ---------------------------------------------------------------------- 
## summarise mean of each .id in groups
mean.feature_stat <- mzmine_table %>% 
  dplyr::rename(.id = `row ID`) %>% 
  dplyr::select(.id, all_of(meta_feature_stat$name)) %>% 
  ## as long table
  reshape2::melt(id.vars = ".id", variable.name = "name", value.name = "value") %>%
  ## get group info
  merge(meta_feature_stat, by = "name", all.x = T) %>% 
  data.table::data.table() %>% 
  ## as numeric
  dplyr::mutate(value = as.numeric(value)) %>% 
  ## group by .id and subgroup
  .[, list(mean = mean(value, na.rm = T)), by = list(.id, subgroup)] %>% 
  ## calculate mean
  dplyr::mutate(mean = ifelse(is.nan(mean), 0, mean)) %>% 
  ## as wide data
  data.table::dcast(.id ~ subgroup, value.var = "mean") %>% 
  dplyr::as_tibble()
## ---------------------------------------------------------------------- 
## ten times fold change
log.fc_stat.ori <- mean.feature_stat %>% 
  dplyr::mutate(`EU-Pro` = `EU-Pro` + 1,
                `EU-Raw` = `EU-Raw` + 1,
                log2fc = log2(`EU-Pro` / `EU-Raw`))
log.fc_stat <- log.fc_stat.ori %>% 
  dplyr::filter(abs(log2fc) >= 1)

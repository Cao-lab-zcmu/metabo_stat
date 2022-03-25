library(MetaboAnalystR)
## ------------------ 
p_col <- c("pro_model#q_value", "pro_model#log2.fc")
## ------------------ 
detach("package:dplyr")
# metabo_idenfication <- meta_metabo_pathway(export, mz_rt, p_col = p_col, ppm = 10, p_cutoff = 0.05, db_pathway = "hsa_mfn", ion_mode = "negative") ## `key`, `as_col`
subm_list <- meta_metabo_pathway(export, mz_rt, p_col = p_col, only_return = T)
## the submit file is got and name as "tmp.txt"
## ------------------------------------- 
## collate file that download from Web of MetaboAnalyst
metabo_results <- metabo_collate(path = "~/Desktop")
## ------------------------------------- 
mutate_mz_rt <- dplyr::mutate(mz_rt, rt = rt * 60)
## get id
metabos <- metabo_get_id_via_mz_rt(metabo_results, mutate_mz_rt)
## gather export with metabos
mutate_export <- lapply(metabos, merge, y = export, by = "id", all.x = T) %>% 
  lapply(dplyr::arrange, name) %>%
  lapply(dplyr::as_tibble) %>% 
  data.table::rbindlist()
## ----------------------------------------------------------------------
## ---------------------------------------------------------------------- 
## ---------------------------------------------------------------------- 
## as pdf table
gt_export <- mutate_export %>%
  # mutate(name = "X") %>%
  dplyr::relocate(id, name, vip) %>%
  pretty_table(spanner = T, shorter_name = F, default = T)


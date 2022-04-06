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
## ---------------------------------------------------------------------- 
## ---------------------------------------------------------------------- 
## ---------------------------------------------------------------------- 
## draw enrichment results 
## ------------------------------------- 
## pathway significant
metabo_pathway <- data.table::rbindlist(metabo_results) %>% 
  dplyr::distinct(pathway, Hits.sig, Gamma)
pathway_horizon(metabo_pathway, title = "pathway enrichment")


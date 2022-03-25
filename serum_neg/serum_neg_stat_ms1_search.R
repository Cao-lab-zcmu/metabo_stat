## some specific structure need to search
comple <- read_tsv("indo_and_phenol.tsv") %>% 
  dplyr::mutate(inchikey2D = stringr::str_extract(inchi, "^[A-Z]{1,1000}"))
## ----------------------------------------------------------------------
## ----------------------------------------------------------------------
## ----------------------------------------------------------------------
# ## phenol structure candidates
# phenol <- read_tsv("phenol.tsv") %>% 
#   dplyr::as_tibble()
# ## inchikey2D search
# search_results <- lapply(comple$inchikey2D, inchikey2d_search,
#                          db = candidates)
# inchikey2d_search(inchikey2D, db, col = "inchikey2D")
## ---------------------------------------------------------------------- 
## ----------------------------------------------------------------------
## ----------------------------------------------------------------------
## ----------------------------------------------------------------------
comple_formula <- inchikey_get_formula(comple$inchi) %>% 
  dplyr::distinct(inchikey, .keep_all = T)
## get possibly precursor
precursor <- formula_adduct_mass(comple_formula$MolecularFormula)
names(precursor) <-  comple$name
## ------------------------------------- 
## ---------------------------------------------------------------------- 
## ---------------------------------------------------------------------- 
## ---------------------------------------------------------------------- 
## precursor search
sig_mz_rt <- dplyr::mutate(mz_rt, sig = ifelse(id %in% export$id, T, F))
mz_search <- multi_formula_adduct_align(precursor, sig_mz_rt, mz_tol = 0.005) %>% 
  data.table::rbindlist(idcol = T, fill = T) %>% 
  dplyr::rename(info = .id) %>% 
  dplyr::mutate(id = as.character(id))
## ------------------------------------- 
much_export <- meta_summarise %>%
  meta_compound_filter(vip = vip, dose = "high",
                       l_abs_log_fc = 0, l_q_value = 1, l_vip = 0)
## ---------------------------------------------------------------------- 
## ---------------------------------------------------------------------- 
## ---------------------------------------------------------------------- 
mz_search_export <- merge(mz_search, much_export, by = "id", all.x = T) %>% 
  dplyr::filter(is.na(vip) == F)
## -------------------------------------
gt_mz_search_export <- mz_search_export %>% 
  pretty_table(spanner = T, shorter_name = F, default = T, title = "Arachidonic acid compound search",
               subtitle = paste0("All search is >>> ", paste(comple$name, collapse = " | ")))


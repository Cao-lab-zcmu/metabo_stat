## ---------------------------------------------------------------------- 
## ---------------------------------------------------------------------- 
## ---------------------------------------------------------------------- 
## stat idenfication
## ---------------------------------------------------------------------- 
## ---------------------------------------------------------------------- 
## ---------------------------------------------------------------------- 
## only classification of dominant stucture is stat
# dominant_stat
dominant_list <- list[which(names(list) %in% dominant_stat$classification)]
## ------------------------------------- 
## filter lower than 0.5
tmp_idset <- dplyr::filter(.MCn.structure_set, tanimotoSimilarity >= 0.5)$.id
## get the sirius summary. this results has integrated with cosmic
sirius_results <- read_tsv("compound_identifications.tsv") %>%
  as_tibble()
sirius <- dplyr::select(sirius_results, formulaRank, InChIkey2D, id) %>%
  dplyr::mutate(.id = stringr::str_extract(id, "(?<=_)[a-z]{1,9}[0-9]{1,5}$")) %>%
  dplyr::select(.id, InChIkey2D, formulaRank) %>%
  ## cut-off with 0.5
  dplyr::filter(.id %in% all_of(tmp_idset)) %>%
  dplyr::rename(inchikey2D = InChIkey2D)
## ------------------------------------- 
## simplify the reference data
mutate_meta <- meta.backup[, c(".id", "INCHIKEY")] %>%
  tidyr::separate(col = "INCHIKEY", into = c("standard", "3d", "chend"),
                  sep = "-") %>%
  dplyr::select(.id, standard)
## ------------------------------------- 
## here, we select InChIkey2D compare with INCHIKEY (standard) to difine 
## whether the idenfication is true
cut.cosmic_accuracy <- stat_accuracy(dominant_list, sirius, mutate_meta)
horizon_bar_accuracy(cosmic_accuracy, title = "",
                     savename = "0.5_cut_sirius_accuracy_bar.svg",
                     return_p = F)
roman_convert("0.5_cut_sirius_accuracy_bar.svg")
## ---------------------------------------------------------------------- 
merge_accuracy_list <- list(`no cut-off` = cosmic_accuracy, `0.5 cut-off` = cut.cosmic_accuracy)
merge_horizon_accuracy(merge_accuracy_list, title = "Identified accuracy",
                       savename = "mcnebula_results/iden.accuracy.svg",
                       return_p = F)


## ---------------------------------------------------------------------- 
## ---------------------------------------------------------------------- 
## ---------------------------------------------------------------------- 
## stat idenfication of molnetenhancer
## ---------------------------------------------------------------------- 
## ---------------------------------------------------------------------- 
## ---------------------------------------------------------------------- 
## gnps database search results
gnps_file <- "/media/wizard/back/test_mcnebula/gnps_pos/mcnebula_results/gnps/molnet/DB_result/b9748de6850b486ea866f283d970a3d5.tsv"
gnps_results <- read_tsv(gnps_file) %>% 
  dplyr::as_tibble() %>% 
  dplyr::select(FileScanUniqueID, `InChIKey-Planar`) %>% 
  dplyr::rename(inchikey2D = `InChIKey-Planar`, .id = FileScanUniqueID) %>% 
  dplyr::mutate(.id = stringr::str_extract(.id, "(?<=mgf)[0-9].*$"),
                .id = paste0("gnps", .id))
## ---------------------------------------------------------------------- 
## gnps accuracy
gnps_accuracy <- stat_accuracy(parallel_molnet, gnps_results, mutate_meta) %>% 
  dplyr::mutate(false = ifelse(is.na(false), 0, false))
horizon_bar_accuracy(gnps_accuracy, title = "gnps accuracy",
                     savename = "mcnebula_results/gnps_accuracy_bar.svg",
                     return_p = F)
roman_convert("mcnebula_results/gnps_accuracy_bar.svg")


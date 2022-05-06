## feature detection is re-performed for sirius computation
## therefore, new results should merge with origin results
## accorling to alignment of mz and rt  
## ---------------------------------------------------------------------- 
## read origin metadata analysis results
origin_analysis <- readxl::read_xlsx("mmc3.xlsx", skip = 1) %>% 
  dplyr::rename(origin_id = Unique_ID,
                origin_mz = `m/z`,
                origin_rt = RT)
sub_origin <- dplyr::select(origin_analysis, 1:3)
## ------------------------------------- 
mzmine_results <- fread("re_align.csv") %>% 
  dplyr::as_tibble()
## select col
mutate_mzmine <- mzmine_results %>% 
  dplyr::select(1:3) %>% 
  dplyr::rename(.id = `row ID`, mz = `row m/z`, rt = `row retention time`)
## ------------------------------------- 
mz_rt <- mutate_mzmine %>% 
  dplyr::mutate(.id = as.character(.id))
## ---------------------------------------------------------------------- 
## do merge
merge_df <- numeric_round_merge(mutate_mzmine, sub_origin,
                                main_col = "mz", sub_col = "origin_mz", num.tol = 0.005) %>% 
  dplyr::filter(abs(rt - origin_rt) <= 0.3) %>% 
  dplyr::as_tibble()
## ---------------------------------------------------------------------- 


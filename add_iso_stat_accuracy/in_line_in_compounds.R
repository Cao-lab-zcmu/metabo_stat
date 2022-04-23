path <- c("/media/echo/DATA/yellow/iso_gnps_pos",
          "/media/echo/DATA/yellow/noise_gnps_pos",
          "/media/echo/DATA/yellow/h_noise_gnps_pos")
## ---------------------------------------------------------------------- 
## batch extraction
all_formula_list <- pbapply::pbmapply(function(path){
                    load(paste0(path, "/", ".RData"))
                    return(.MCn.formula_set)
          }, path, SIMPLIFY = F)
names(all_formula_list) <- path
## ---------------------------------------------------------------------- 
## merge to get compounds in common
common_compounds <- all_formula_list %>%
  data.table::rbindlist(idcol = T) %>% 
  dplyr::rename(file = 1)
common_compounds <- table(common_compounds$.id) %>% 
  .[which(. == 3)] %>% 
  names() %>% 
  data.table(.id = .)
## ---------------------------------------------------------------------- 
## exclude iodine
iodine <- read_tsv(paste0(path[1], "/mcnebula_results/msms_pos_gnps.msp.meta.tsv")) %>% 
  dplyr::filter(grepl("I", FORMULA)) %>% 
  dplyr::select(.id) %>% 
  unlist(use.names = F) 
## ---------------------------------------------------------------------- 
ex.iod.common_compounds <- common_compounds %>% 
  dplyr::filter(!.id %in% iodine)
## ---------------------------------------------------------------------- 
## write as table
write_tsv(ex.iod.common_compounds, file = "/media/echo/DATA/yellow/common_compounds.tsv")


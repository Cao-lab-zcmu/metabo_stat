## RT is not available for all strucutre
## this part, the RT is download from Retip web (github), 
## which is simulated via retip computation
## however, even that, RT is not enough for all structure
## as some structure without RT, this part only stat for the
## structure which harbour RT
## ---------------------------------------------------------------------- 
## first, sirius accuracy should be stated
tmp_format <- function(id_set){
  .MCn.nebula_index <- dplyr::filter(.MCn.nebula_index, .id %in% id_set)
  source("~/outline/add_iso_stat_accuracy/format_nebula_index.R", local = T)
  return(list)
}
re_list <- tmp_format(rt_meta$.id)
## ------------------------------------- 
tmp_idenfication <- function(re_list){
  list <- re_list
  ## backup
  file <- "mcnebula_results/sirius_accuracy_bar.svg"
  ## origin as other
  file.rename(file, paste0(file, ".back"))
  source("~/outline/add_iso_stat_accuracy/idenfication_stat.R", local = T)
  ## new svg rename
  file.rename(file, paste0(get_path(file), "/less_", get_filename(file)))
  ## origin as origin
  file.rename(paste0(file, ".back"), file)
  return(cosmic_accuracy)
}
re_sirius_accuracy <- tmp_idenfication(re_list)

## from mgf (sirius format) to gnps
file <- "/media/wizard/back/test_mcnebula/mgf/h_noise_gnps_pos.mgf"
## read
list <- filter_mgf(filter_id = NULL,
                   file = file)
args <- list(list = list, mass_process_level_2 = F, discard_level1 = T, filter_empty = F)
## discard level 1 and as list
level2_list <- do.call(spectrum_add_noise, args)
## filter empty
level2_list <- lapply(level2_list, is.data.frame) %>%
  unlist %>%
  level2_list[.]
## ------------------------------------- 
## the format or insert line is:
# SCANS
# CHARGE
# RTINSECOUNDS
# MERGED_STATS
gnps_mgf <- pbapply::pblapply(level2_list, mgf_add_anno.gnps, cl = 8)
## bind
gnps_mgf <- data.table::rbindlist(gnps_mgf)
## revise rt and charge
gnps_mgf <- dplyr::mutate(gnps_mgf, V1 = gsub("RTINSECONDS=", "RTINSECONDS=1000", V1),
                          V1 = gsub("CHARGE=+1", "CHARGE=1+", V1),
                          V1 = gsub("FEATURE_ID=gnps", "FEATURE_ID=", V1))
## write mgf
write.table(gnps_mgf, "/media/wizard/back/test_mcnebula/gnps_pos/mcnebula_results/gnps/gnps.h_noise_gnps_pos.mgf",
            quote = F, col.names = F, row.names = F)
## ---------------------------------------------------------------------- 
## quant table
msp <- "/media/wizard/back/test_mcnebula/gnps_pos/mcnebula_results/gnps/msms_pos_gnps.msp"
gnps_metadata <- read_tsv(paste0(msp, ".meta.tsv"))
## simulate quant csv
quant_meta <- simulate_gnps_quant(gnps_metadata, get_path(msp), return_df = T)
## filter according to level2_list
quant_meta <- dplyr::filter(quant_meta, `row ID` %in%
                            stringr::str_extract(names(level2_list), "[0-9]{1,}$"),
                          `row m/z` <= 800)
file= "/media/wizard/back/test_mcnebula/gnps_pos/mcnebula_results/gnps/gnps.h_noise_quant.csv"
write.table(quant_meta, file = file, sep = ",", row.names = F, col.names = T, quote = F)
 

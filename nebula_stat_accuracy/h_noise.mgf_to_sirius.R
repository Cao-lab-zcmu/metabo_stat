## add noise
list <- filter_mgf(filter_id = NULL,
                   file = "~/Downloads/msp/msms_pos_gnps.msp.mgf")
## ------------------------------------- 
## noise pool is collate from pre-proccess sirius project,
## which the simulated noise has not been added into yet
## first, get valid noise
valid_list <- load_all_valid_spectra()
## merge and get noise
noise_pool <- collate_as_noise_pool(list, valid_list)
## ------------------------------------- 
## the main function to add noise peak as well as doing mass shift
list <- spectrum_add_noise(list,
                           int.sigma = 2^(1/2),
                           global.sigma = 15/3 * 1e-6,
                           indivi.sigma = 15/3 * 1e-6,
                           sub.factor = 0.03,
                           alpha = 0.4,
                           .noise_pool = noise_pool)
## ------------------------------------- 
mgf_df <- data.table::rbindlist(list)
write.table(mgf_df, "/media/wizard/back/test_mcnebula/mgf/h_noise_gnps_pos.mgf",
            quote = F, col.names = F, row.names = F)


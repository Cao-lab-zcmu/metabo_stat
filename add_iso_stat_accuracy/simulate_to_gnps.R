## in order to compare MCnebula with gnps and molenhancet
## here, sirius mgf is re-formated for gnps mgf
## as well as, metadata is simulated as gnps quant table
msp <- "/media/wizard/back/test_mcnebula/gnps_pos/mcnebula_results/gnps/msms_pos_gnps.msp"
## set function to get gnps mgf
msp_to_mgf(get_filename(msp),
           id_prefix = "",
           path = get_path(msp),
           fun = "deal_with_msp_record",
           pre_modify = F,
           mass_level = 2,
           set_rt = 1000,
           add_scans = T)
## get_metadata
gnps_metadata <- read_tsv(paste0(msp, ".meta.tsv"))
## simulate quant csv
simulate_gnps_quant(gnps_metadata, get_path(msp))
## ---------------------------------------------------------------------- 


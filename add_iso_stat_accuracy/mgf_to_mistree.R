## GNPS qemistree use sirius as tool to 
## predict structure
## however, the version of sirius soft utilized by GNPS
## is not compatible with comment sirius mgf
## therefore, herein the comment sirius mgf is convert to 
## qemistree mgf
## ------------------------------------- 
## mgf
file <- c("iso_gnps_pos.mgf",
          "noise_gnps_pos.mgf",
          "h_noise_gnps_pos.mgf")
filepath <- paste0("/media/wizard/back/test_mcnebula/mgf/", file)
## ------------------------------------- 
## save name
save_set <- c("origin.mgf",
              "noise.mgf",
              "h_noise.mgf")
## ------------------------------------- 
## read
savepath <- "/media/wizard/back/test_mcnebula/mgf/qemistree_mgf/"
## batch trans 
for(i in 1:length(filepath)){
  file <- filepath[i]
  savename <- save_set[i]
  ## ------------------------------------- 
  cat("Processing:", file, "\n")
  list <- filter_mgf(filter_id = NULL,
                     file = file)
  # ------------------------------------- 
  mistree <- pbapply::pblapply(list, mgf_add_anno.mistree, cl = 8)
  ## as df
  mistree <- data.table::rbindlist(mistree)
  ## revise rt and charge and id
  mistree <- dplyr::mutate(mistree, V1 = gsub("RTINSECONDS=$", "RTINSECONDS=1000", V1),
                            V1 = gsub("CHARGE=+1", "CHARGE=1+", V1),
                            V1 = gsub("FEATURE_ID=gnps", "FEATURE_ID=", V1))
  ## write mgf
  write.table(mistree, paste0(savepath, savename), quote = F, col.names = F, row.names = F)
}

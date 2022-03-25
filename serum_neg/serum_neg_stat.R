## sample name annotation
GROUP <- c(blank_ = "blank", C = "control", M = "model", P = "positive",
           SL = "raw_low", SM = "raw_medium", SH = "raw_high",
           YL = "pro_low", YM = "pro_medium", YH = "pro_high")
## ---------------------------------------------------------------------- 
## set palette
palette <- c(control = "grey", model = "#374E55FF", drug = "#00A087FF",
             ## red for pro group
             pro_low = "#FDAE6BFF", pro_medium = "#FD8D3CFF", pro_high = "#E6550DFF",
             ## blue for raw group
             raw_low = "#9ECAE1FF", raw_medium = "#6BAED6FF", raw_high = "#3182BDFF")
## ---------------------------------------------------------------------- 
## ---------------------------------------------------------------------- 
## ---------------------------------------------------------------------- 
## ---------------------------------------------------------------------- 
## R codes for meta analyses
file <- "./batch_serum_neg.csv"
feature_csv <- data.table::fread(file) %>%
  dplyr::as_tibble()
## ----------------------------------------------------------------------  
## gather peak_area
peak_area <- feature_csv %>%
  dplyr::select(contains("ID"), contains("Peak area"))
## ------------------------------------- 
mz_rt <- dplyr::select(feature_csv, 1:3)
colnames(mz_rt) <- c("id", "mz", "rt")
## ------------------ 
mz_rt <- mz_rt %>%
  dplyr::mutate(id = as.character(id))
## ------------------------------------- 
## collate metadata
metadata <- colnames(peak_area)[2:ncol(peak_area)] %>%
  meta_get_metadata()
## ------------------------------------- 
db_get_sample <- meta_do_list(metadata)
## all sample name and group and super group have been collate
## ---------------------------------------------------------------------- 
## ---------------------------------------------------------------------- 
## ---------------------------------------------------------------------- 
## in order to get that matrix
# |multi |multi |multi |cp   |cp   |cp   |
# |:-----|:-----|:-----|:----|:----|:----|
# |c1    |c1    |c1    |base |base |base |
# |c1    |c1    |c1    |base |base |base |
# |c1    |c1    |c1    |base |base |base |
# |c2    |c2    |c2    |c3   |c3   |c3   |
## ------------------------------------- 
## all compare couple
## base part
compare <- metadata$group %>%
  meta_get_couple()
## ------------------------------------- 
extra_compare <- compare %>%
  meta_get_extra_couple()
## ---------------------------------------------------------------------- 
## ---------------------------------------------------------------------- 
## ---------------------------------------------------------------------- 
## to get facet pca plot
## pca analyses
compute_df <- as_pca_df(peak_area)
## calculate
pca_set <- pca_via_group(df = compute_df, compare = compare,
                         extra_compare = extra_compare,
                         db_get_sample = db_get_sample)
## ------------------------------------- 
## visualize pca
plot <- visualize_facet_pca(pca_set, palette, metadata)
## ---------------------------------------------------------------------- 
## ---------------------------------------------------------------------- 
## ---------------------------------------------------------------------- 
## to get VIP value
## opls-da analyses
## only compare control with model
opls_set <- meta_oplsda(compute_df, metadata, c("control", "model"))
## get vip dataset
vip <- opls_set$vip
## ---------------------------------------------------------------------- 
## ---------------------------------------------------------------------- 
## ---------------------------------------------------------------------- 
## trans df format
mutate_peak_area <- compute_df %>%
  meta_array_to_df(., metadata)
## ------------------------------------- 
## calculate log2FC, p-value, q-value
meta_summarise <- meta_summarise_via_group(df = mutate_peak_area, compare = compare)
## ---------------------------------------------------------------------- 
## ---------------------------------------------------------------------- 
## ---------------------------------------------------------------------- 
## do specific dosage dispose
export <- meta_summarise %>%
  meta_compound_filter(vip = vip, dose = "high",
                       l_abs_log_fc = 1, l_q_value = 0.05)
## ----------------------------------------------------------------------
## ----------------------------------------------------------------------
## ----------------------------------------------------------------------
## module metabo analysis
## ---------------------------------------------------------------------- 
## ---------------------------------------------------------------------- 
## ---------------------------------------------------------------------- 
## model MCnebula cluster
## ---------------------------------------------------------------------- 
## ---------------------------------------------------------------------- 
## MS 1 search
## ---------------------------------------------------------------------- 
## ---------------------------------------------------------------------- 
## ---------------------------------------------------------------------- 

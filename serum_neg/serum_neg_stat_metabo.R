library(MetaboAnalystR)
## ------------------ 
p_col <- c("pro_model#q_value", "pro_model#log2.fc")
## ------------------ 
detach("package:dplyr")
# metabo_idenfication <- meta_metabo_pathway(export, mz_rt, p_col = p_col, ppm = 10, p_cutoff = 0.05, db_pathway = "hsa_mfn", ion_mode = "negative") ## `key`, `as_col`
subm_list <- meta_metabo_pathway(export, mz_rt, p_col = p_col, only_return = T)
## the submit file is got and name as "tmp.txt"
## ------------------------------------- 
## collate file that download from Web of MetaboAnalyst


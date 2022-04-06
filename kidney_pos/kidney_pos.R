## this script run source of serum_neg stat, to identically
## stat kidney pos data
source("~/operation/superstat.R")
file <- "~/operation/batch_kidney_pos/batch_kidney_pos.csv"
## run script of serum_neg stat
source("~/outline/serum_neg/serum_neg_stat.R")
## the `export` is the stat results
## ---------------------------------------------------------------------- 
source("~/outline/serum_neg/serum_neg_stat_metabo.R")
## ------------------------------------- 
source("~/outline/serum_neg/serum_neg_stat_metabo_collate.R")
## ---------------------------------------------------------------------- 

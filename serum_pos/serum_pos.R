## this script run source of serum_neg stat, to identically
## stat serum pos data
source("~/operation/superstat.R")
file <- "~/operation/batch_serum_pos/batch_serum_pos.csv"
## run script of serum_neg stat
source("~/outline/serum_neg/serum_neg_stat.R")
## the `export` is the stat results
## ---------------------------------------------------------------------- 
source("~/outline/serum_neg/serum_neg_stat_metabo.R")
## ------------------------------------- 
source("~/outline/serum_neg/serum_neg_stat_metabo_collate.R")
## ---------------------------------------------------------------------- 

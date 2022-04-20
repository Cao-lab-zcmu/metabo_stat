## format qi csv as metaboanalyst input
## read as raw data
file <- "mice fece.csv"
## ------------------------------------- 
metadata <- qi_get_format(file, metadata = T)
## ---------------------------------------------------------------------- 
df <- qi_get_format(file)
## ------------------------------------- 
select <- c("Control", "HFD")
## ------------------------------------- 
export <- qi_as_metabo_inte.table(df, metadata, select)


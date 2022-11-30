## format qi csv as metaboanalyst input
## read as raw data
file <- list.files(pattern = "serum_neg.csv")
metadata <- qi_get_format(file, metadata = T)
group <- metadata$group %>% 
  unique()
df <- qi_get_format(file)
## ---------------------------------------------------------------------- 
contr.1 <- group[!grepl("QC|BLANK|KB|MODEL", group)]
contr.df <- data.table::data.table(
  contr.1 = contr.1,
  contr.2 = "MODEL"
)
contr.df <- data.table::data.table(
  contr.1 = contr.1[1:4],
  contr.2 = contr.1[6:9]
) %>% 
  dplyr::bind_rows(contr.df)
## ------------------------------------- 
## ========== Run block ========== 
pbapply::pbapply(contr.df, 1, function(contr){
                   export <- qi_as_metabo_inte.table(df, metadata, contr)
                   savename <- paste(contr, collapse = "_vs_")
                   savename <- paste0(savename, ".format.csv")
                   write.table(export, savename,
                               sep = ",", col.names = T,
                               row.names = F, quote = F)
})


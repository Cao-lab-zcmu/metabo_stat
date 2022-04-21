## format qi csv as metaboanalyst input
## read as raw data
file_set <- list.files(pattern = "csv$") %>%
  .[!grepl("format", .)]
pbapply::pblapply(file_set, function(file){
                    metadata <- qi_get_format(file, metadata = T)
                    ## ---------------------------------------------------------------------- 
                    df <- qi_get_format(file)
                    ## ------------------------------------- 
                    select <- metadata$group %>%
                      unique() %>%
                      .[1:2]
                    ## ------------------------------------- 
                    export <- qi_as_metabo_inte.table(df, metadata, select)
                    ## ------------------------------------- 
                    savename <- paste0(file, ".format.csv")
                    write.table(export, savename, sep = ",", col.names = T, row.names = F, quote = F)
})
## ------------------------------------- 


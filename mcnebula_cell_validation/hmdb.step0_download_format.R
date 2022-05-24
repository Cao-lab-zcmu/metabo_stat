## get HMDB metabolities database
url <- "https://hmdb.ca/system/downloads/current/structures.zip"
## ------------------------------------- 
path <- "hmdb_compound"
dir.create(path)
file <- "hmdb_compound/hmdb.zip"
## download
system(paste0("curl ", url, " > ", file))
## unpack
system(paste0("unzip ", "-d hmdb_compound ", file))
## ------------------------------------- 
hmdb.sdf <- ChemmineR::read.SDFset(paste0(path, "/structures.sdf"))
## save rdata
save(hmdb.sdf, file = paste0(path, "/hmdb_sdf.rdata"))
## ---------------------------------------------------------------------- 
## convert to list
n <- length(hmdb.sdf)
hmdb.list <- list()
length(hmdb.list) <- n
## for loop
for(i in 1:n){
  hmdb.list[i] <- ChemmineR::datablock(hmdb.sdf[i])
  cat("## Now >>>", i, "\n")
}
rm("hmdb.sdf")
## ------------------------------------- 
## to data.frame
hmdb.df <- pblapply(hmdb.list, bind_rows)
## as df in each list
hmdb.df <- data.table::rbindlist(hmdb.df, fill = T)
## gather
hmdb.df <- dplyr::as_tibble(hmdb.df)
## save df
save(hmdb.df, file = paste0(path, "/hmdb_df.rdata"))


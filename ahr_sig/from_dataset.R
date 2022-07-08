## R
## metadata
## path <- "~/operation/geo_db/ahr_sig"
## ---------------------------------------------------------------------- 
## ========== Run block ========== 
meta <- data.table::fread("series.csv") %>% 
  dplyr::filter(grepl("Expression", `Series Type`), 
                grepl("Homo sapiens", Taxonomy)) %>% 
  dplyr::as_tibble() 
## ---------------------------------------------------------------------- 
## Use wget to download data
apply(dplyr::mutate(meta, seq = 1:nrow(meta)), 1,
      function(vec){
        cat("[Info] Downloading seq of", vec[["seq"]], "\n")
        gse <- vec[["Accession"]]
        gse.dir <- gsub("[0-9]{3}$", "nnn", gse)
        ftp <- paste0("ftp://ftp.ncbi.nlm.nih.gov/geo/series/", gse.dir, "/", gse, "/suppl/")
        system(paste("wget -np -m", ftp))
      })
## ---------------------------------------------------------------------- 
## test for download data
## ------------------------------------- 
# file <- list.files(pattern = test)
# info.t <- GEOquery::getGEO(filename = file)
# ## ---------------------------------------------------------------------- 
# df <- Biobase::phenoData(info.t)
# name.sample <- Biobase::sampleNames(df)
# ## ------------------------------------- 
# sample <- GEOquery::getGEO(name.sample[1])
# sample.df <- GEOquery::Table(sample)
# ## ---------------------------------------------------------------------- 

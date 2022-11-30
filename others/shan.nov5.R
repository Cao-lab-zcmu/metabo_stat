# https://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/cid/2244/synonyms/XML
# setwd("~/operation/shang")

# devtools::load_all("~/utils.tool/R")
# pubchem_get_synonyms("2244", ".")

# check_pkg <- function(){
#   packages <- c("data.table", "dplyr", "pbapply", "RCurl", "XML")
#   lapply(packages,
#          function(pkg){
#            if (!requireNamespace(pkg, quietly = T))
#              install.packages(pkg)
#          })
# }

## load function
source("~/utils.tool/R/pubchem.R")
## install packages
check_pkg()
## data save path
path <- "~/operation/shang/"
## usage
pubchem_get_synonyms(cid = c("2244"), dir = path)
## load data
cid_set <- extract_rdata_list(paste0(path, "/cid.rdata"))


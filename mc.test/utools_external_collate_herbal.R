
Sys.time()
# [1] "2023-01-02 15:33:34 CST"
Sys.info()
#                                                            sysname 
#                                                            "Linux" 
#                                                            release 
#                                          "5.17.5-76051705-generic" 
#                                                            version 
# "#202204271406~1653440576~22.04~6277a18 SMP PREEMPT Wed May 25 01" 
#                                                           nodename 
#                                                           "pop-os" 
#                                                            machine 
#                                                           "x86_64" 
#                                                              login 
#                                                             "echo" 
#                                                               user 
#                                                             "echo" 
#                                                     effective_user 
#                                                             "echo" 

devtools::load_all("~/MCnebula2")
mcn_herbal <- mcnebula()
mcn_herbal <- initialize_mcnebula(mcn_herbal, "sirius.v4", "/media/echo/DATA/yellow/eucommia/neg/")
mcn_herbal <- collate_used(mcn_herbal)
# latest(mcn_herbal, , ".f2_formula")

## ------------------------------------- decrease size
## structure
df <- entity(dataset(project_dataset(mcn_herbal))[[ ".f3_fingerid" ]])
df <- dplyr::mutate(df, links = character(1), pubmed.ids = character(1))
df <- dplyr::mutate_if(df, is.numeric, function(x) round(x, 2))
entity(dataset(project_dataset(mcn_herbal))[[ ".f3_fingerid" ]]) <- df

## formula
df2 <- entity(dataset(project_dataset(mcn_herbal))[[ ".f2_formula" ]])
df2 <- dplyr::mutate_if(df2, is.numeric, function(x) round(x, 2))
entity(dataset(project_dataset(mcn_herbal))[[ ".f2_formula" ]]) <- df2

## class
df3 <- entity(dataset(project_dataset(mcn_herbal))[[ ".f3_canopus" ]])
df3 <- dplyr::mutate_if(df3, is.numeric, function(x) round(x, 2))
df3 <- dplyr::mutate(df3, description = character(1),
                     rel.index = as.integer(rel.index))
entity(dataset(project_dataset(mcn_herbal))[[ ".f3_canopus" ]]) <- df3

## ------------------------------------- save
mcn_herbal1612 <- mcn_herbal
format(object.size(mcn_herbal1612), units = "MB")
save(mcn_herbal1612, file = "~/utils.tool/inst/extdata/mcn_herbal1612.rdata")
# load("~/utils.tool/inst/extdata/mcn_herbal1612.rdata")

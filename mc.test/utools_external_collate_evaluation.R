
Sys.time()
# [1] "2023-01-30 14:44:43 CST"
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

dirs <- c(
  "/media/echo/DATA/yellow/iso_gnps_pos",
  "/media/echo/DATA/yellow/noise_gnps_pos",
  "/media/echo/DATA/yellow/h_noise_gnps_pos"
)

lst <- lapply(dirs,
  function(dir) {
    mcn <- mcnebula()
    mcn <- initialize_mcnebula(mcn, "sirius.v4", dir)
    mcn <- collate_used(mcn)
    ## ------------------------------------- decrease size
    ## structure
    df <- entity(dataset(project_dataset(mcn))[[ ".f3_fingerid" ]])
    df <- dplyr::mutate(df, links = character(1), pubmed.ids = character(1))
    df <- dplyr::mutate_if(df, is.numeric, function(x) round(x, 2))
    entity(dataset(project_dataset(mcn))[[ ".f3_fingerid" ]]) <- df
    ## formula
    df2 <- entity(dataset(project_dataset(mcn))[[ ".f2_formula" ]])
    df2 <- dplyr::mutate_if(df2, is.numeric, function(x) round(x, 2))
    entity(dataset(project_dataset(mcn))[[ ".f2_formula" ]]) <- df2
    ## class
    df3 <- entity(dataset(project_dataset(mcn))[[ ".f3_canopus" ]])
    df3 <- dplyr::mutate_if(df3, is.numeric, function(x) round(x, 2))
    df3 <- dplyr::mutate(df3, description = character(1),
      rel.index = as.integer(rel.index))
    entity(dataset(project_dataset(mcn))[[ ".f3_canopus" ]]) <- df3
    mcn
  })

names(lst) <- paste0(c("", "median_noise_", "high_noise_"), "gnps_pos.rdata")

format(object.size(lst), units = "MB")
## ------------------------------------- save

lapply(names(lst),
  function(name) {
    mcn <- lst[[ name ]]
    save(mcn, file = paste0("~/utils.tool/inst/extdata/evaluation/", name))
  })


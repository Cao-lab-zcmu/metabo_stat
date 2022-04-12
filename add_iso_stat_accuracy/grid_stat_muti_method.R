## before this, all method has accomplished the
## analysis of simulation dataset, which involves
## origin spectrum, medium noise specturm, and high level noise specturm
## of LC-MS.
## these data are in different R project
## hence, herein these output table are extracted and 
## draw stat plot.
## ------------------------------------- 
## set envir to store these dataset
envir_name <- c("origin", "noise", "h_noise")
## create envire
lapply(envir_name, function(name){
         assign(name, new.env(), envir = parent.frame(2))
})
## ------------------------------------- 
## extract var
var <- c("dominant_stat", "extra_dominant",
         "molnet_dominant_stat", "m_extra_dominant")
## ---------------------------------------------------------------------- 
path <- c("/media/echo/DATA/yellow/iso_gnps_pos",
          "/media/echo/DATA/yellow/noise_gnps_pos",
          "/media/echo/DATA/yellow/h_noise_gnps_pos")
## ---------------------------------------------------------------------- 
## batch extraction
pbapply::pbmapply(function(path, envir_name, var){
                    load(paste0(path, "/", ".RData"))
                    lapply(var, function(var){
                             assign(var, eval(parse(text = var)), envir = get(envir_name)) }
                    )}, path, envir_name,
          MoreArgs = list(var = var))
## ---------------------------------------------------------------------- 

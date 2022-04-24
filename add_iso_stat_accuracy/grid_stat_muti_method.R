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
pbapply::pbmapply(function(path, envir_name, VAR){
                    load(paste0(path, "/.RData"))
                    lapply(VAR, function(var){
                             assign(var, eval(parse(text = var)), envir = get(envir_name)) }
                    )
          }, path, envir_name,
          MoreArgs = list(VAR = var))
## ---------------------------------------------------------------------- 
## as list
lapply(var, function(var){
         list <- lapply(parse(text = paste0(envir_name, "$", var)), eval)
         names(list) <- envir_name
         assign(paste0("list_", var), list, envir = parent.frame(2))
         return()
          })
# ---------------------------------------------------------------------- 
## get classification data
lapply("/media/echo/DATA/yellow/h_noise_gnps_pos/.RData",
       function(file){
         load(file)
         .MCn.class_tree_data <<- .MCn.class_tree_data
         return()
       })
## plot results
## ------------------------------------- 
## MCnebula
mutate2_horizon_bar_accuracy(list_dominant_stat,
                            title = "MCnebula tolerance",
                            savename = "mc_noise_tolerance_bar.svg",
                            extra_list = list_extra_dominant)
## ------------------------------------- 
## MolnetEnhancer
mutate2_horizon_bar_accuracy(list_molnet_dominant_stat,
                            title = "MolnetEnhancer tolerance",
                            savename = "molnet_noise_tolerance_bar.svg",
                            extra_list = list_m_extra_dominant,
                            l_ratio = 62,
                            m_ratio = 110,
                            y_cut_left = c(50, 700),
                            y_cut_right = c(800, 2500),
                            y_cut_left_breaks = c(50, seq(100, 700, by = 200)),
                            y_cut_right_breaks = c(1400, 2000),
                            width = 24)
## ---------------------------------------------------------------------- 
## ---------------------------------------------------------------------- 
## ---------------------------------------------------------------------- 
plot.facet_compare(list_extra_dominant,
                   list_m_extra_dominant,
                   title = "Clustering comparation",
                   savename = "facet_compare.svg")

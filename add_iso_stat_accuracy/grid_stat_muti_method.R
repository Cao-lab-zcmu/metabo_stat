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
## ---------------------------------------------------------------------- 
path <- c("",
          "/media/echo",
          "/media/echo/")

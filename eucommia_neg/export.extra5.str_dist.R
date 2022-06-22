## ------------------------------------- 
## stringdist::afind
## test
res.list <- pbapply::pblapply(format.lite,
                              function(lite){
                                res.vec <- stringdist::amatch(syno.metadata$syno,
                                                              lite,
                                                              nthread = 10,
                                                              maxDist = 3)
                                return(res.vec)
                              })


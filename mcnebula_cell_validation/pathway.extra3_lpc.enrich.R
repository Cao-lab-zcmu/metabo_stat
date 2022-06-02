## ---------------------------------------------------------------------- 
lpc.stat <- do.call(args = list(),
                    function(){
                      source("~/outline/mcnebula_cell_validation/pathway.extra.clone_lpc.enrich.R",
                             local = T)
                      lpc.stat <- ba.stat
                      return(lpc.stat)
                    })


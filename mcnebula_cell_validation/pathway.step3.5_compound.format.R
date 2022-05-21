## G1, G2... 
inmap.format <- inmap.list %>% 
  lapply(function(list){
           ## each compound
           list <- lapply(list,
                  function(list2){
                    type <- c(
                              "ENTRY",
                              "NAME",
                              "BRITE",
                              "PATHWAY"
                    )
                    list2 <- list2[names(list2) %in% type]
                    # unlist(list2, use.names = F)
                  })
           return(list)}) %>% 
  unlist(recursive = F)
## ------------------------------------- 
## output
dir.create("pathway")
inmap.format %>% 
  lapply(function(list){
           file.name = paste0("pathway/", list$ENTRY, ".txt")
           capture.output(list, file = file.name)
           })

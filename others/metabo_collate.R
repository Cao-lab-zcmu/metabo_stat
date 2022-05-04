## path 
dir <- c("liver", "cecum", "fece", "serum")
## sub path
sub.dir <- dir %>% 
  lapply(list.files, pattern = "^[^\\.]{1,}$", full.names = T) %>% 
  unlist(use.names = F)
## ---------------------------------------------------------------------- 
pbapply::pblapply(sub.dir, function(path){
                    metabo_results <- metabo_collate(path = path)
                    metabo_pathway <- data.table::rbindlist(metabo_results) %>% 
                      dplyr::distinct(pathway, Hits.sig, Gamma)
                    pathway_horizon(metabo_pathway, title = "pathway enrichment",
                                    save = paste0(path, "/", "enrichment.svg"))
})


## load latest dataset
if(!exists("fella.data")){
  fella.data <- FELLA::loadKEGGdata(databaseDir = graph.dir, 
                                    internalDir = FALSE, 
                                    loadMatrix = c("hypergeom",
                                                   "diffusion",
                                                   "pagerank"))
}
## ---------------------------------------------------------------------- 
## compounds
cpd.nafld <- unique(kegg$KEGG)
## merge syno find in pubchem database
if(exists("kegg.syno.from.pub")){
  cpd.nafld <- c(cpd.nafld, kegg.syno.from.pub$query) %>% 
    unique()
}
## ---------------------------------------------------------------------- 
## enrich
analysis.nafld <- FELLA::enrich(compounds = cpd.nafld,
                                data = fella.data,
                                method = FELLA::listMethods(),
                                approx = "normality")
## ------------------------------------- 
inmap <- analysis.nafld %>% 
  FELLA::getInput()
## ------------------------------------- 
## query
inmap.list <- inmap %>% 
  ## for kegg, max number 10
  MCnebula::grouping_vec2list(10) %>% 
  ## vector loop
  lapply(KEGGREST::keggGet)


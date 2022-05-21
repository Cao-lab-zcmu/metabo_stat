## FELLA build grapth
## random seed
if(!file.exists("graph.dir")){
  set.seed(1)
  ## human pathway
  hsa.graph <- FELLA::buildGraphFromKEGGREST(organism = "hsa")
  ## save hsa.graph
  save(hsa.graph, file = "hsa.graph.Rdata")
  ## graph save path
  graph.dir <- paste0("kegg_database")
  ## unlink previous 
  unlink(graph.dir, recursive = TRUE)
  ## time-cosummed
  FELLA::buildDataFromGraph(keggdata.graph = hsa.graph,
                            databaseDir = graph.dir,
                            internalDir = FALSE,
                            matrices = c("hypergeom", "diffusion", "pagerank"),
                            normality = c("diffusion", "pagerank"),
                            dampingFactor=0.85,
                            niter = 100)
}

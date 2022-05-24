## test
# hs.pathways <- rWikiPathways::listPathways('Homo sapiens')
## ------------------------------------- 
# dep.test <- rWikiPathways::getPathwayInfo('WP554')
## ------------------------------------- 
# pathway <- "WP554"
## download graphml
# gpml.list <- rWikiPathways::getPathway(pathway)
## to file
# wiki.graph <- "wiki_graph/"
# if(!file.exists(wiki.graph))
#   dir.create(wiki.graph)
# ## to file
# gpml.list <- mapply(
#                     function(char, name){
#                       cat(char, file = paste0(wiki.graph, name, ".graphml"))
                    # }, gpml.list, pathway)
## ------------------------------------- 
# gpm <- igraph::read_graph(paste0(wiki.graph, pathway[1], ".graphml"),
                          # format = "graphml")
# ## text query
# ac.pathways <- rWikiPathways::findPathwaysByText('"Acyl carnitines"')
# mol.query <- rWikiPathways::getXrefList('WP554', 'Ch')
## ------------------------------------- 
hs.pathways <- rWikiPathways::listPathways('Homo sapiens')
## ------------------------------------- 
wiki.cpd <- pbapply::pblapply(hs.pathways$id,
                             function(id){
                               check <- 0
                               while(check == 0 | class(check)[1] == "try-error"){
                                 check <- try(cpd <- rWikiPathways::getXrefList(id, 'Ch'),
                                              silent = T)
                                 return(cpd)
                               }
                             }) 
names(wiki.cpd) <- hs.pathways$id
save(wiki.cpd, file = "hmdb_compound/wiki_cpd.rdata")


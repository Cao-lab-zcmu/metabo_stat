## test
hs.pathways <- rWikiPathways::listPathways('Homo sapiens')
## ------------------------------------- 
dep.test <- rWikiPathways::getPathwayInfo('WP554')
## ------------------------------------- 
pathway <- "WP554"
## download graphml
gpml.list <- rWikiPathways::getPathway(pathway)
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
mol.query <- rWikiPathways::getXrefList('WP554', 'Ch')



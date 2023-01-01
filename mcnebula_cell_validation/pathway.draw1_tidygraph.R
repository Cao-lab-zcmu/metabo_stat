## ggraph to draw plot
tidy.graph <- tidygraph::as_tbl_graph(graph)

## nodes
nodes <- tidy.graph %>%
  tidygraph::activate(nodes) %>%
  dplyr::as_tibble() %>% 
  dplyr::select(-entrez) %>% 
  dplyr::mutate(NAME = unlist(lapply(NAME, 
                                     function(vec)
                                       vec[1]
                                     )),
                abb.name = stringr::str_trunc(NAME, 15, "right"),
                type = sapply(name,
                              function(char){
                                char <- stringr::str_extract(char,
                                                             "^[^[0-9]]{1,3}|\\.")
                                char <- ifelse(stringr::str_length(char) > 1,
                                               "pathway",
                                               char)
                                char <- switch(char,
                                               pathway = "Pathway",
                                               M = "Module",
                                               "." = "Enzyme",
                                               C = "Compound",
                                               R = "Reaction")
                                return(char)
                              }),
                type = unname(type),
                input_compound = ifelse(name %in% inmap, "Input compound", "Others"))

## output
if(!file.exists("pathway"))
  dir.create("pathway")
## write tab sep table
write_tsv(nodes, "pathway/open_with_excel.nodes.tsv")
## write graph
igraph::write_graph(graph,
                    file = "pathway/open_with_cytoscape.graphml",
                    format = "graphml")

## edges
edges <- tidy.graph %>%
  tidygraph::activate(edges) %>%
  ## rename the col of value of compare spectra
  dplyr::as_tibble()

tidy.graph <- tidygraph::tbl_graph(nodes = nodes, edges = edges)


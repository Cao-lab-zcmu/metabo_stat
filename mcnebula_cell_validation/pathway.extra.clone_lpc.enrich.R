## draw ba pathway
## change script
script.ba.subm <- "~/outline/mcnebula_cell_validation/submit_to_metabo.cid.R" %>% 
  data.table::fread(sep = NULL, header = F) %>% 
  dplyr::as_tibble()
script.ba.subm[20, ] <- script.ba.subm[20, ] %>% 
  sub("Infection", "Mortality", .)
script.ba.subm[21, ] <- "extra.compound = NULL"
## ---------------------------------------------------------------------- 
## 6-15
# script.ba.subm <- dplyr::slice(script.ba.subm, -(6:16))
heat.class <- "Lysophosphatidylcholines"
script.ba.subm <- dplyr::bind_rows(script.ba.subm[1:6, ],
                                   c(V1 = paste0("'", heat.class, "'")),
                                   script.ba.subm[17:nrow(script.ba.subm), ])
## ---------------------------------------------------------------------- 
## ------------------------------------- 
script.ba.subm <- paste0(script.ba.subm$V1, collapse = "\n")
tmp <- tempfile()
cat(script.ba.subm, file = tmp)
## ------------------------------------- 
sig.inchikey2d.back <- sig.inchikey2d
## ------------------ 
source(tmp)
sig.ba <- sig.inchikey2d
## ------------------ 
source("~/outline/mcnebula_cell_validation/pathway.step1_cid2kegg.metabo.R")
## ------------------------------------- 
script.ba.subm <- "~/outline/mcnebula_cell_validation/pathway.step3_fella.enrich.R" %>% 
  data.table::fread(sep = NULL, header = F) %>% 
  dplyr::as_tibble()
script.ba.subm <- dplyr::slice(script.ba.subm, -(13:16))
script.ba.subm <- paste0(script.ba.subm$V1, collapse = "\n")
tmp <- tempfile()
cat(script.ba.subm, file = tmp)
source(tmp)
## ------------------------------------- 
source("~/outline/mcnebula_cell_validation/pathway.step5_fella.pagerank.R")
source("~/outline/mcnebula_cell_validation/pathway.draw1_tidygraph.R")
source("~/outline/mcnebula_cell_validation/pathway.draw2_ggraph.R")
sig.inchikey2d <- sig.inchikey2d.back
## ---------------------------------------------------------------------- 
## get source data
## ---------------------------------------------------------------------- 
ba.path.inchi <- merge(kegg, cid_inchikey, by.y = "CID", by.x = "PubChem", all.x = T) %>% 
  ## inchikey2d
  merge(.MCn.structure_set[, c(".id", "inchikey2D")], by = "inchikey2D", all.x = T) %>% 
  ## get id and origin_id
  merge(merge_df[, c(".id", "origin_id")], by = ".id", all.x = T) %>% 
  dplyr::filter(KEGG %in% all_of(inmap)) %>% 
  dplyr::as_tibble()
## ------------------------------------- 
source("~/outline/mcnebula_cell_validation/heatmap.path_step1_df.prep.R")
text <- readLines("~/outline/mcnebula_cell_validation/heatmap.path_step2_draw.R")[1:12] %>% 
  paste0(collapse = "\n")
source(exprs = parse(text = text))
## get heatmap
## ---------------------------------------------------------------------- 
ba.stat <- data.table::data.table(heat.norm.df.l) %>% 
  dplyr::mutate(subgroup = stringr::str_extract(sample, "^[A-Z]{2}")) %>% 
  ## use data.table for aggregation 
  .[, list(mean = mean(value, na.rm = T)), by = list(origin_id, no.name, subgroup)] %>% 
  tidyr::spread(key = subgroup, value = mean) %>% 
  dplyr::filter(no.name %in% all_of(ba.path.inchi$.id),
                origin_id %in% export.dominant$`origin id`) %>% 
  ## get kegg
  merge(ba.path.inchi[, c("origin_id", "KEGG")], all.x = T, by = "origin_id") %>% 
  ## merge to get NAME
  merge(nodes[, c("name", "NAME")], by.x = "KEGG", by.y = "name", all.x = T) %>% 
  distinct(origin_id, .keep_all = T) %>% 
  ## manual name
  dplyr::as_tibble()
  ## calculate mean

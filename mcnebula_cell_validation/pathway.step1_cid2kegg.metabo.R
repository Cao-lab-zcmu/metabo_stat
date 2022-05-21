## use MetaboAnalystR to convert cid to kegg ID
## cid: path.cid
kegg <- MetaboAnalystR::InitDataObjects("conc", "msetora", FALSE) %>% 
  ## load cid
  MetaboAnalystR::Setup.MapData(path.cid[[1]]) %>% 
  ## curl database
  MetaboAnalystR::CrossReferencing("pubchem") %>% 
  ## get table
  MetaboAnalystR::CreateMappingResultTable()
## extract kegg ID
kegg <- kegg$dataSet$map.table %>%
  dplyr::as_tibble() %>%
  dplyr::filter(KEGG != "NA")

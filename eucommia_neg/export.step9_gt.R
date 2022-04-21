## ---------------------------------------------------------------------- 
## export
gt_table <- pretty_table(dplyr::rename(export.dominant[, -ncol(export.dominant)], info = Classification),
                         title = "E. ulmoides compounds summary",
                         subtitle = "LC-MS in negative ion mode",
                         footnote = "Compounds listed in table are identified from Raw-Eucommia or Pro-Eucommia. These compounds are grouped by classes which selected manually. As compounds not only belong to a class and also belong to the parent classes, for this case, the compounds are preferentially considered for subtile classes.",
                         default = F) %>% 
  ## add footnote
  ## name
  tab_footnote(footnote = "The names are synonyms or IUPAC names of these compounds or their stereoisomers.",
               locations = cells_column_labels(columns = Name)) %>% 
  ## similarity
  tab_footnote(footnote = "Tanimoto similarities are calculated by CSI:fingerID for evaluation of compound fingerprints match.",
               locations = cells_column_labels(columns = `Tanimoto similarity`)) %>% 
  ## InChIKey
  tab_footnote(footnote = "The 'InChIKey planar' is the first hash block of InChIKey that represents a molecular skeleton.",
               locations = cells_column_labels(columns = `InChIKey planar`))


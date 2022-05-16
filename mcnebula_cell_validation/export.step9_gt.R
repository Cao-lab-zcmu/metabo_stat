## ---------------------------------------------------------------------- 
## export
gt_table <- pretty_table(dplyr::rename(export.dominant[, -ncol(export.dominant)],
                                       info = Classification,
                                       `ID` = `id`,
                                       `Original ID` = `origin id`),
                         title = "Serum metabolomic compounds summary",
                         subtitle = "LC-MS in positive ion mode",
                         footnote = "Compounds listed in table were identified from serum metabolomic dataset. These compounds were grouped by classes. As compounds not only belong to one class and also belong to its parent classes, for this case, the compounds were preferentially considered for subtile classes.",
                         default = F) %>% 
  ## add footnote
  ## name
  tab_footnote(footnote = "The names were synonyms or IUPAC names of these compounds or their stereoisomers.",
               locations = cells_column_labels(columns = Name)) %>% 
  ## similarity

  tab_footnote(footnote = "Tanimoto similarities were obtained via CSI:fingerID for evaluation of compound fingerprints match.",
               locations = cells_column_labels(columns = `Tanimoto similarity`)) %>% 
  ## InChIKey
  tab_footnote(footnote = "The 'InChIKey planar' is the first hash block of InChIKey that represents a molecular skeleton.",
               locations = cells_column_labels(columns = `InChIKey planar`)) %>% 
  tab_footnote(footnote = "The ID was generated while MZmine2 processing and were inherited in subsequent MCnebula workflow.",
               locations = cells_column_labels(columns = `ID`)) %>% 
  tab_footnote(footnote = "The original ID was in line with the feature ID in study of Wozniak et al.",
               locations = cells_column_labels(columns = `Original ID`)) %>% 

  tab_footnote(footnote = "The mass error were obtained via SIRIUS while predicting formula of compounds.",
               locations = cells_column_labels(columns = `Mass error (ppm)`))




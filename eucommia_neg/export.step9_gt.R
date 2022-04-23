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
               locations = cells_column_labels(columns = `InChIKey planar`)) %>% 
  tab_footnote(footnote = "All identified formulae are in adduct of '[M - H]-'.",
               locations = cells_column_labels(columns = `Formula`)) %>% 
  tab_footnote(footnote = "Id are generated while MZmine2 processing and are inherited in subsequent MCnebula workflow.",
               locations = cells_column_labels(columns = `Id`)) %>% 
  tab_footnote(footnote = "The mass error are calculated by SIRIUS while predicting formula of compounds.",
               locations = cells_column_labels(columns = `Mass error (ppm)`)) %>% 
  tab_footnote(footnote = "The variation are difined as: ↑ or ↓ indicates increasing or decreasing of compound content after E. ulmoides being processed, whereas - indicates no apparent alteration; and the number of arrow imply the magnitude of alteration, i.e., integer of |log2(FC)|. FC is defined as Pro-Eucommia compare with Raw-Eucommia.",
               locations = cells_column_labels(columns = `Variation`))




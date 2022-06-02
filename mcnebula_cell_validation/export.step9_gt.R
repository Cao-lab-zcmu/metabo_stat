## ---------------------------------------------------------------------- 
## export
gt_table <- pretty_table(dplyr::rename(export.dominant[, -ncol(export.dominant)],
                                       info = Classification,
                                       `ID` = `id`,
                                       `Original ID` = `origin id`),
                         title = "Serum metabolomic compounds summary",
                         subtitle = "LC-MS in positive ion mode",
                         footnote = "Compounds listed in table were identified from serum metabolomic dataset. These compounds are grouped by classes. As compounds not only belong to one class and also belong to its parent classes, for this case, the compounds are preferentially grouped for subtile classes.",
                         default = F)
## add footnote
## name
gt_table <- tab_footnote(gt_table,
                         footnote = "The names are synonyms or IUPAC names of these compounds or their stereoisomers.",
                         locations = cells_column_labels(columns = Name))
## similarity

gt_table <- tab_footnote(gt_table, footnote = "Tanimoto similarities were obtained via CSI:fingerID for evaluation of compound fingerprints match.",
                         locations = cells_column_labels(columns = `Tanimoto similarity`))
## InChIKey
gt_table <- tab_footnote(gt_table, footnote = "The 'InChIKey planar' is the first hash block of InChIKey that represents a molecular skeleton.",
                         locations = cells_column_labels(columns = `InChIKey planar`))
gt_table <- tab_footnote(gt_table, footnote = "The ID was generated while MZmine2 processing and are inherited in subsequent MCnebula workflow.",
                         locations = cells_column_labels(columns = `ID`))
gt_table <- tab_footnote(gt_table, footnote = "The original ID is in line with the feature ID in study of Wozniak et al.",
                         locations = cells_column_labels(columns = `Original ID`))

gt_table <- tab_footnote(gt_table, footnote = "The mass error were obtained via SIRIUS while predicting formula of compounds.",
                         locations = cells_column_labels(columns = `Mass error (ppm)`))




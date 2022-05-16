## export table
bio_gt_table <- pretty_table(align.export,
                             group = F,
                             title = "Top metabolites of serum dataset",
                             subtitle = "LC-MS in positive ion mode",
                             footnote = "The top 25 ensemble feature selection (EFS) metabolites and the 2 top Mann-Whitney U (MWU) tests metabolites were collated from previous study of Wozniak et al. The original feature list was aligned with re-analyzed feature list (0.01 m/z tolerance and 0.3 min retention time tolerance).",
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
  tab_footnote(footnote = "The ID was generated while MZmine2 processing and inherited in subsequent MCnebula workflow.",
               locations = cells_column_labels(columns = `ID`)) %>% 
  tab_footnote(footnote = "The original ID, precursor m/z, RT were in line with those of features in study of Wozniak et al.",
               locations = cells_column_labels(columns = c(`Original ID`,
                                                           `Original precursor m/z`,
                                                           `Original RT (min)`))) %>% 
  tab_footnote(footnote = "The results of spectral library match were obtained from study of Wozniak et al.",
               locations = cells_column_labels(columns = `Spectral Library Match`))


# ---------------------------------------------------------------------- 
# in order to validate whether sirius performce well while the ms/ms data
# without reference specturm library, next, the top structure of csi:fingerid
# were collate.
# ------------------------------------- 
csi_structure <- collate_top_score_structure() %>%
  dplyr::select(.id, inchikey2D) %>%
  as_tibble()
csi_accuracy <- stat_accuracy(dominant_list, csi_structure, mutate_meta)
## this results are completely identical with cosmic_accuracy
## that is, the summary of sirius is excuted based on top csi:fingerid score

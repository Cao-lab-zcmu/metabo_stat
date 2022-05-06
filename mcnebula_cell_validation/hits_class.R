## whether bio_4m has identified by sirius
sirius_efs25.status <- sirius_efs25 %>% 
  merge(bio_4m[, c("origin_id", "Spectral_Library_Match")], by = "origin_id", all.x = T) %>% 
  dplyr::as_tibble()
## simplify
sirius_efs25.simp <- sirius_efs25.status %>% 
  dplyr::filter(!is.na(inchikey2D)) %>% 
  dplyr::select(.id, inchikey2D, name,
                tanimotoSimilarity, origin_id,
                Spectral_Library_Match) %>%
  dplyr::arrange(origin_id, desc(tanimotoSimilarity)) %>% 
  dplyr::mutate(Spectral_Library_Match = gsub("Spectral Match to ", "", Spectral_Library_Match))
## ---------------------------------------------------------------------- 
## origin_id: 670
## check hits class
diacy.id <- sirius_efs25.simp %>%
  dplyr::filter(origin_id == 670) %>% 
  dplyr::select(.id) %>% 
  unlist()
diacy.id.lcms <- merge_efs25 %>% 
  dplyr::filter(.id %in% diacy.id)


## stat all identified structure, find
## high confidence score compound
## and collate them for group of classification
## ------------------------------------- 
## get the real classification via classyfire
export.struc_set <- .MCn.structure_set %>% 
  dplyr::filter(tanimotoSimilarity >= 0.5)
## ---------------------------------------------------------------------- 
## curl pubchem to get possibbly inchikey3d
dir.create("pubchem")
pubchem_curl_inchikey(export.struc_set$inchikey2D, dir = "pubchem",
                      curl_cl = 8)
## ------------------------------------- 
## classify
dir.create("classyfire")
batch_get_classification(export.struc_set$inchikey2D,
                         dir_pubchem = "pubchem",
                         dir_classyfire = "classyfire",
                         classyfire_cl = 8)


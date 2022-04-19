## find AC class
ac_compound <- origin_analysis %>% 
  dplyr::select(origin_id, Class, Subclass, Spectral_Library_Match) %>% 
  dplyr::filter(grepl(".arnitin.|Fatty acid esters", Subclass) |
                grepl(".arnitin.", Class) |
                grepl(".arnitin.", Spectral_Library_Match)) %>% 
  dplyr::mutate(Spectral_Library_Match = gsub("Spectral Match to ", "", Spectral_Library_Match)) %>% 
  dplyr::filter(Spectral_Library_Match != "NA")
## documented ACs compounds
ac_names <- c("Palmitoyl-carnitine", "Octanoyl-carnitine",
              "Acetyl-carnitine", "Hexanoyl-carnitine",
              "Decanoyl-carnitine")
ac_inchikey2d <- c("XOMRRQXKHMYMOC", "CXTATJFJDMJMIY",
                   "RDHQFKQIGNGIED", "VVPRQWTYSNDTEA",
                   "LZOSYCMHQXPBFU")
ac_compound.docu <- data.table::data.table(name = ac_names, inchikey2d = ac_inchikey2d)
## ---------------------------------------------------------------------- 
## tmp_nebula_index
ac_index <- dplyr::filter(tmp_nebula_index, grepl(".carni.", name))
## ------------------------------------- 
## get top50
## ------------------------------------- 
## top50.ac_structure <- read_tsv("top50_ac.compound.tsv")
## ------------------------------------- 
ac_compound.docu$inchikey2d %in% .MCn.structure_set$inchikey2D
## ---------------------------------------------------------------------- 
# ac_compound.struc_set <- .MCn.structure_set %>% 
  # dplyr::filter(inchikey2D %in% ac_compound.docu$inchikey2d)
## ---------------------------------------------------------------------- 

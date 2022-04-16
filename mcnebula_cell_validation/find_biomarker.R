## top identified compounds
## The top ranked, identified metabolites include:
## ------------------------------------- 
## 2-Hexadecanoylthio-1-Ethylphosphorylcholine (HEPC, Figure S1H)
bio.hepc <- "Hepc"
## sphingosine-1-phosphate (S1P, Figure S1I)
bio.s1p <- "D-erythro-Sphingosine-1-phosphate"
## ------------------
## by EFS and
## ------------------ 
## thyroxine (T4, Figure S1J)
bio.t4 <- "L-THYROXINE"
## decanoyl-carnitine (Figure S1K)
bio.dec <- "Decanoyl-L-carnitine"
## ------------------
## by MWU test.
## ------------------------------------- 
bio_set <- ls(pattern = "bio\\.") %>% 
  lapply(get) %>% 
  unlist()
## get match
origin_sp.match <- origin_analysis %>%
  dplyr::filter(Spectral_Library_Match != "NA")
## the 4 matched compound
bio_4m <- origin_sp.match %>% 
  .[unlist(lapply(bio_set, grep,
                  x = .$Spectral_Library_Match,
                  ignore.case = T)), ]
## ---------------------------------------------------------------------- 
efs_top25.origin_id <- c(349, 746, 854, 228, 320, 971, 2532, 670, 92, 1363,
                         13, 798, 1379, 1947, 4146, 736, 1656, 464, 731, 289,
                         4431, 3865, 476, bio_4m$origin_id)


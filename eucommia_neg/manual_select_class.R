## ---------------------------------------------------------------------- 
## extract classyfire data
## do a rough filter
class_df <- extract_rdata_list("classyfire/class.rdata",
                                 export.struc_set$inchikey2D) %>% 
  data.table::rbindlist(idcol = T) %>% 
  dplyr::rename(inchikey2d = .id) %>% 
  dplyr::filter(!Level %in% all_of(c("kingdom", "level 7", "level 8", "level 9")),
                !grepl("[0-9]|Organ|Phenylpropanoids and polyketides", Classification))
## ---------------------------------------------------------------------- 
## the classes keeped
## do further filter
keep <- class_df$Classification %>%
  table() %>% 
  data.table::data.table() %>% 
  dplyr::filter(N >= 7, N < 100) %>% 
  dplyr::rename(class = 1, abund = 2)
## ------------------------------------- 
## set abundance db
abund.db <- lapply(keep$abund, c)
names(abund.db) <- keep$class
## ------------------------------------- 
## get parent class
parent.class <- mutate_get_parent_class(keep$class, class_cutoff = 3, this_class = F)
## final auto discard
discard <- mapply(function(c.name, vec){
                    if(is.null(vec)){
                      return()
                    }
                    vec <- vec[vec %in% names(abund.db)]
                    if(length(vec) == 0)
                      return()
                    vec <- lapply(vec, function(class){abund.db[[class]]}) %>% 
                      unlist(use.names = F)
                    ref <- abund.db[[c.name]]
                    check <- vec - ref
                    check <- 0:3 %in% check
                    if(T %in% check){
                      return(c.name)
                    }
                }, names(parent.class), parent.class) %>%
  unlist(use.names = F)
## ------------------------------------- 
keep2 <- dplyr::filter(keep, !class %in% all_of(discard))
## ------------------------------------- 
manual_exclude <- c("O-glycosyl compounds",
                    "Oligosaccharides",
                    "Medium-chain hydroxy acids and derivatives",
                    "Monosaccharides",
                    "Benzenediols",
                    "Benzenoids",
                    "Benzoic acids and derivatives",
                    "Aldehydes",
                    "Hydroxy acids and derivatives",
                    "Hydroxy fatty acids",
                    "Keto acids and derivatives",
                    "Ketones",
                    "Hydroxybenzoic acid derivatives",
                    "Benzene and substituted derivatives",
                    "Carbonyl compounds")
## ------------------------------------- 
keep3 <- dplyr::filter(keep2, !class %in% all_of(manual_exclude))
## ---------------------------------------------------------------------- 
class_meta <- class_df %>%
  dplyr::filter(Classification %in% keep3$class)

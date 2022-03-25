## Rscript
## for mining more dimentimonal data, the gradient of 
## liquid phase is considered.
## in order to get reference dataset, firstly, the 
## dataset download from MoNA should be reshape.
metadata_path <- "~/Downloads/msp/MoNA/MoNA-export-MassBank.msp.meta.tsv"
## ------------------------------------- 
metadata <- read_tsv(metadata_path) %>% 
  dplyr::as_tibble()
## -------------------------------------
## positive ion mode is stat first
metadata <- dplyr::filter(metadata, charge == 1)
supp <- collate_comment(metadata$Comments, metadata$.id)
## reshape the supplementary metadata
mutate_supp <- supp %>% 
  data.table::rbindlist(idcol = T) %>% 
  dplyr::as_tibble()
## get all type of comment
comment_type <- mutate_supp$comment %>% 
  unique()
## ---------------------------------------------------------------------- 
## Chromatography relative 
# test <- comment_type[c(17, 18, 19, 21, 22, 56)]
# test <- dplyr::filter(mutate_supp, comment %in% test) %>% 
#   by_group_as_list("comment") %>% 
#   lapply(dplyr::rename, evaluate = record) %>% 
#   lapply(table_app, prop = F) %>% 
#   lapply(function(v){
#            df <- data.table::data.table(class = names(v), value = unlist(v, use.names = F))
#            return(df)
#       }) %>% 
#   data.table::rbindlist(idcol = T) %>% 
#   dplyr::mutate(class = paste0(1:nrow(.), ": ", stringr::str_extract(class, "^.{1,20}"), "..."))
# ## visualization
# generic_horizon_bar(test,
#                     title = "chromatography conditions",
#                     save = "~/Pictures/chroma_condition.svg")
## ---------------------------------------------------------------------- 
## ---------------------------------------------------------------------- 
## ---------------------------------------------------------------------- 
## for most important annotation, filter to get RT
rt_supp <- dplyr::filter(mutate_supp, comment == "retention time")
## ---------------------------------------------------------------------- 
## ---------------------------------------------------------------------- 
## ---------------------------------------------------------------------- 
## flow gradient
flowg_supp <- dplyr::filter(mutate_supp, comment == "flow gradient")
## select the most abundance flow gradient method
stat <- mutate_stat <- flowg_supp$record %>%
  table()
names(mutate_stat) <- paste0("method", 1:length(stat))
#  method1  method2  method3  method4  method5  method6  method7  method8
#        4       21        2       49       89      293      150      356
#  method9 method10 method11 method12 method13 method14 method15 method16
#      450       16        3      405      223       33      223      129
# method17 method18 method19 method20 method21 method22 method23 method24
#      299      143        9       63      136       90     7653      660
# method25 method26 method27 method28 method29 method30 method31 method32
#       51       52       64     4086       60      207      239     1634
# method33 method34 method35 method36 method37 method38 method39 method40
#     3241      622      224      207        2     4085       38      782
# method41 method42 method43
#       75      704       16
## overall, method23 is the most abundance method
## get the method23 gradient flow details
sflow <- names(stat)[23]
## the data belong to sflow
sflow_id <- dplyr::filter(mutate_supp, record == sflow)$.id
## check metadata belong to sflow_id
sflow_metadata <- dplyr::filter(metadata, .id %in% sflow_id)
## ---------------------------------------------------------------------- 
## ---------------------------------------------------------------------- 
## ---------------------------------------------------------------------- 

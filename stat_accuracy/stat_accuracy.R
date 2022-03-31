## Rscript
## path <- "/media/wizard/back/test_mcnebula/gnps_pos"
## library(MCnebula)
## ---------------------------------------------------------------------- 
## metadata
meta <- read_tsv("mcnebula_results/msms_pos_gnps.msp.meta.tsv") %>%
  dplyr::as_tibble()
class_meta <- dplyr::select(meta, .id, Ontology)
## ---------------------------------------------------------------------- 
## ---------------------------------------------------------------------- 
## pubchem
## ---------------------------------------------------------------------- 
## ---------------------------------------------------------------------- 
## via pubchem, get standard Inchikey
load_all("~/extra/R")
dir.create("inchi_csv")
setwd("inchi_csv")
## metadata
dload <- dplyr::select(meta, .id, INCHIKEY) %>%
  tidyr::separate(col = "INCHIKEY", into = c("init", "3d", "end"), sep = "-", remove = T) %>%
  dplyr::select(.id, init)
## multi-threading
pbapply::pblapply(1:nrow(dload), int_inchi_curl, cl = 20)
## -------------------------------------
 
## read csv and gather
file_set <- list.files(pattern = "^gnps[0-9]{1,5}\\.csv$")
list <- pbapply::pblapply(file_set, data.table::fread)
names(list) <- gsub(".csv", "", file_set)
## as df
df <- data.table::rbindlist(list, idcol = T)
lapply(file_set, file.remove)
## ---------------------------------------------------------------------- 
## ---------------------------------------------------------------------- 
## classyfireR
## ---------------------------------------------------------------------- 
## ---------------------------------------------------------------------- 
## check whether data of all .id has got
# all_id <- dload$".id"
# omit_id <- all_id[!all_id %in% df$".id"]
## get the row number of omit_id
# seq <- which(all_id %in% omit_id)
## ------------------------------------- 
## repeat gather
## ------------------------------------- 
setwd("..")
dir.create("classyfire")
setwd("classyfire")
## use classyfireR
library(classyfireR)
## a time-consuming computation
## submit inchi to classyfire web one by one
df <- read_tsv("../inchi_csv/pubchem_inchikey.tsv") %>%
  dplyr::as_tibble()
silent <- auto_classy(df, cl = 8)
## ------------------------------------- 
## save data
# save(envir_store, file = "envir_store.rdata")
## stat all
# id_set <- ls(envir = envir_store)
## ---------------------------------------------------------------------- 
## the above, all compound data were collate,
## involving metadata and classification data, curl via
## classyfireR
## the following, these data were compared with
## MCnebula computation results, involving
## clustering and idenfication
## ---------------------------------------------------------------------- 
## nebula class
class_nebula <- dplyr::ungroup(.MCn.nebula_index) %>%
  dplyr::select(.id, hierarchy, name)
# index <- dplyr::distinct(class_nebula, hierarchy, name)
## ------------------------------------- 
## as list
class_nebula_list <- extra::by_group_as_list(class_nebula, "name")
list <- list_merge_df(class_nebula_list, class_meta, by = ".id", all.x = T)
list <- lapply(list, select_app,
               col = c(".id", "hierarchy", "Ontology"))
## ------------------------------------- 
## ------------------------------------- 
## ------------------------------------- 
## stat cluster
## ------------------------------------- 
## ------------------------------------- 
## main stat
## ------------------------------------- 
## ------------------------------------- 
## stat dominant structure classification
stat_list <- mapply(stat_results_class, list, names(list),
                    path = "classyfire",
                    SIMPLIFY = F)
stat_table <- lapply(stat_list, table_app, prop = T)
## gather data
stat <- data.table::rbindlist(stat_table, fill = T, idcol = T) %>%
  dplyr::rename(classification = .id) %>%
  dplyr::summarise_all(na_as)
dominant_stat <- dplyr::filter(stat, false <= 0.4)
## ------------------------------------- 
## ------------------------------------- 
## ------------------------------------- 
## sides plot
## ------------------------------------- 
## ------------------------------------- 
# sum number in each classification
extra_stat_table <- lapply(stat_list, table_app, prop = F) %>%
  data.table::rbindlist(fill = T, idcol = T) %>%
  dplyr::rename(classification = .id) %>%
  dplyr::summarise_all(na_as)
extra_dominant <- merge(extra_stat_table, dplyr::select(dominant_stat, classification),
                        by = "classification", all.y = T) %>%
  mutate(., sum = apply(dplyr::select(., 2:4), 1, sum)) %>%
  dplyr::select(classification, sum)
##------------------------------------- 
## ------------------------------------- 
## ------------------------------------- 
## plot a bar to show accuracy intuitively
mutate_horizon_bar_accuracy(dominant_stat, title = "clustering accuracy",
                            savename = "mcnebula_results/cluster_accuracy_bar.svg",
                            extra_sides_df = extra_dominant,
                            return_p = F)
roman_convert("mcnebula_results/cluster_accuracy_bar.svg")
## ------------------------------------- 
## ------------------------------------- 
## classyfire class distribution
reference_density <- get_reference_class_density()
those_level_inclass <- get_reference_class_parent(reference_density)
## ------------------------------------- 
## ------------------------------------- 
## compare with nebula index
those_of_nebula <- stat$classification %>%
  mutate_get_parent_class(this_class = T) %>%
  lapply(end_of_vector) %>%
  unlist() %>%
  unname() %>%
  unique()
## ------------------------------------- 
## ------------------------------------- 
## ------------------------------------- 
## mean value
# mean_dominant_stat <- dplyr::summarise_at(dominant_stat, 2:4, mean)
## ------------------------------------- 
## ------------------------------------- 
## sub_stat
## ------------------------------------- 
## ------------------------------------- 
## stat sub-structural classification
## which possiboly be sub-structural classification
sub_stat <- dplyr::filter(stat, false >= 0.4)
sub_stat_list <- stat_list[which(names(stat_list) %in% sub_stat$"classification")]
sub_stat_list <- lapply(sub_stat_list, dplyr::select, id)
df <- dplyr::select(meta, .id, SMILES)
## merge smiles into list
sub_stat_list <- pbapply::pblapply(sub_stat_list, merge,
                        y = df, by.x = "id", by.y = ".id",
                        all.x = T)
## ------------------ 
## get prepared pattern set
file_set <- list.files("~/extra/data", full.names = T)
pattern_set <- lapply(file_set, function(x){
                        dplyr::slice(read_txt(x), 1)
                        })
names(pattern_set) <- stringr::str_extract(file_set, "(?<=data/).*$")
## ------------------ 
## order list to keep names of two list in line
pattern_set <- order_list(pattern_set)
sub_stat_list <- order_list(sub_stat_list)
sub_test <- mapply(struc_match_in_df,
                   sub_stat_list,
                   unlist(pattern_set),
                   SIMPLIFY = F)
## ------------------
## results
stat_sub_test <- lapply(sub_test, table_app) %>%
  data.table::rbindlist(idcol = T, fill = T) %>%
  dplyr::rename(classification = .id)
## ------------------ 
## conclusion
# stat
# dominant_stat
# stat_sub_test
## ---------------------------------------------------------------------- 
## ---------------------------------------------------------------------- 
## ---------------------------------------------------------------------- 
## stat idenfication
## ---------------------------------------------------------------------- 
## ---------------------------------------------------------------------- 
## ---------------------------------------------------------------------- 
## only classification of dominant stucture is stat
# dominant_stat
dominant_list <- list[which(names(list) %in% dominant_stat$classification)]
## ------------------------------------- 
## get the sirius summary. this results has integrated with cosmic
sirius_results <- read_tsv("compound_identifications.tsv") %>%
  as_tibble()
sirius <- dplyr::select(sirius_results, formulaRank, InChIkey
2D, id) %>%
  dplyr::mutate(.id = stringr::str_extract(id, "(?<=_)[a-z]{1,9}[0-9]{1,5}$")) %>%
  dplyr::select(.id, InChIkey2D, formulaRank) %>%
  dplyr::rename(inchikey2D = InChIkey2D)
## ------------------------------------- 
## simplify the reference data
mutate_meta <- meta[, c(".id", "INCHIKEY")] %>%
  tidyr::separate(col = "INCHIKEY", into = c("standard", "3d", "chend"),
                  sep = "-") %>%
  dplyr::select(.id, standard)
## ------------------------------------- 
## here, we select InChIkey2D compare with INCHIKEY (standard) to difine 
## whether the idenfication is true
cosmic_accuracy <- stat_accuracy(dominant_list, sirius, mutate_meta)
horizon_bar_accuracy(cosmic_accuracy, title = "sirius accuracy",
                     savename = "mcnebula_results/sirius_accuracy_bar.svg",
                     return_p = F)
roman_convert("mcnebula_results/sirius_accuracy_bar.svg")
## ---------------------------------------------------------------------- 
## ---------------------------------------------------------------------- 
## ---------------------------------------------------------------------- 
# MCnebula aims to elevate accuracy of strucutre idenfication
# as the accuracy of clustering results much better than idenfication,
# possibly, there were enouph space to get batter of idenfacation
# test rerank algorithm
# ------------------------------------- 
# as the rerank algorithm may revise the df
# backup_structure <- .MCn.structure_set
# backup_formula <- .MCn.formula_set
# # ------------------------------------- 
# # -------------------------------------  
# stat_method <- lapply(dominant_stat$"classification", test_rerank_method,
#                       meta = mutate_meta,
#                       top_n = 5)
# names(stat_method) = dominant_stat$classification
# stat_method <- data.table::rbindlist(stat_method, idcol = T) %>%
#   dplyr::rename(classification = .id)
## ---------------------------------------------------------------------- 
## plot with origin accuracy
# merge_accuracy_list <- list(origin = cosmic_accuracy, re_rank = stat_method)
# mutate_merge_horizon_accuracy(merge_accuracy_list, title = "re_rank accuracy",
#                        savename = "mcnebula_results/re_rank_accuracy.svg",
#                        return_p = F)
# ---------------------------------------------------------------------- 
## in order to validate whether sirius performce well while the ms/ms data
## without reference specturm library, next, the top structure of csi:fingerid
## were collate.
## ------------------------------------- 
# csi_structure <- collate_top_score_structure() %>%
#   dplyr::select(.id, inchikey2D) %>%
#   as_tibble()
# csi_accuracy <- stat_accuracy(dominant_list, csi_structure, mutate_meta)
# ## this results are completely identical with cosmic_accuracy
# ## that is, the summary of sirius is excuted based on top csi:fingerid score
## ------------------------------------- 
## ---------------------------------------------------------------------- 
## a formula pick method was applied in MCnebula. to verify the validity...
pick_method_accuracy <- stat_accuracy(dominant_list, backup_structure, mutate_meta)
## ---------------------------------------------------------------------- 
## ---------------------------------------------------------------------- 
## ---------------------------------------------------------------------- 
## ---------------------------------------------------------------------- 
## whether MCnebula is deserved to development, is mostly depends on whether
## CSI:fingerID gathered the true structure into candidate.
## if there is no true structure in dataset, most of the compounds in nebula,
## there is no mean to do cluster or rerank
## so, a test is performed
## ------------------------------------- 
## get top n candidate
nebula_name <- dominant_stat$classification %>% 
  unique()
lapply(nebula_name, nebula_get_candidate)
## ------------------------------------- 
candidates_accuracy <- stat_topn_candidates_accuracy(dominant_stat$classification,
                                                     meta = mutate_meta)
## draw plot
horizon_bar_accuracy(candidates_accuracy, title = "all candidates accuracy",
                     savename = "mcnebula_results/mutate50_candidates_accuracy_bar.svg",
                     return_p = F)
roman_convert("mcnebula_results/candidates_accuracy_bar.svg")
## ---------------------------------------------------------------------- 
## ---------------------------------------------------------------------- 
## ---------------------------------------------------------------------- 
## merge accuracy plot 
merge_accuracy_list <- list(top1 = cosmic_accuracy, top50 = candidates_accuracy)
merge_horizon_accuracy(merge_accuracy_list, title = "candidates accuracy",
                       savename = "mcnebula_results/top1_vs_top50_accuracy.svg",
                       return_p = F)
## ---------------------------------------------------------------------- 


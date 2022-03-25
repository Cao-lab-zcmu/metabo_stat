## gather sirius. a number of compounds candidate were collate
## and further annatate with classification
## here, classyfireR is used to add annotation of classification
## ---------------------------------------------------------------------- 
## ---------------------------------------------------------------------- 
candidates <- read_tsv("indo.tsv") %>% 
  dplyr::mutate(sp.id = rownames(.)) %>% 
  dplyr::as_tibble()
## ------------------------------------- 
## search pubchem
mutate_inchi_curl(candidates$inchikey2D, candidates$sp.id)
## gather data
pub_instance <- gather_inchi_curl() %>% 
  dplyr::rename(.id = sp.id)
## ------------------ 
mutate_auto_classy(pub_instance, cl = 20)
## gather classyfire
simp_candi <- meta_gather_pub_classyfire_sirius(pub_instance, "Indoles and derivatives", candidates)
## ---------------------------------------------------------------------- 
system("rm -r inchi_pub")
## re-collate compound via pubchem
mutate_inchi_curl(simp_candi$inchikey2D, simp_candi$sp.id, get = "IUPACName")
system("rm -r inchi_pub")
## gather
name_df <- gather_inchi_curl() %>% 
  dplyr::distinct(sp.id, .keep_all = T)
## as export
indo_export <- meta_re_collate_iupac_via_inchi(simp_candi, name_df, export)
## ---------------------------------------------------------------------- 
## ---------------------------------------------------------------------- 
## ---------------------------------------------------------------------- 
## mannualy adjust name >>> syno_backup
gt_indo_export <- indo_export %>% 
  pretty_table(spanner = T, shorter_name = F, default = T)
## ---------------------------------------------------------------------- 
## ---------------------------------------------------------------------- 
## the manipulation across through classyfire. therefore if databse without
## the compounds, the classification annotation possibly be leaving out
## this step re-search some compouns
mutate_inchi_curl_syno(candidates$inchikey2D, candidates$sp.id)


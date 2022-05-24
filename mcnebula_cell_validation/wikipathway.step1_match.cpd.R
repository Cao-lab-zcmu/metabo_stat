## load hmdb compound data
## hmdb.df
if(!exists("hmdb.df")){
  load("hmdb_compound/hmdb_df.rdata")
}
hmdb.df <- dplyr::select(hmdb.df, INCHI_KEY, DATABASE_ID) %>% 
  dplyr::mutate(inchikey2D = stringr::str_extract(INCHI_KEY, "^[A-Z]{1,}"))
## load wiki pathway ID and inchikey
## wiki.cpd
if(!exists("wiki.cpd"))
  load("hmdb_compound/wiki_cpd.rdata")
## ---------------------------------------------------------------------- 
sig.df <- sig.inchikey2d %>% 
  dplyr::select(.id, inchikey2D) %>% 
  # dplyr::filter(.id %in% ac_index$.id) %>% 
  ## merge to get hmdb id
  merge(hmdb.df, by = "inchikey2D", all.x = T) %>% 
  dplyr::filter(!is.na(INCHI_KEY)) %>% 
  dplyr::as_tibble()
## ------------------------------------- 
freq <- mapply(
               function(pathway.vec, path.name, cpd){
                 tt <- table(cpd %in% pathway.vec)
                 if("TRUE" %in% names(tt)){
                   cpd <- cpd[cpd %in% pathway.vec]
                   cpd <- dplyr::filter(sig.df, DATABASE_ID %in% all_of(cpd))
                   ## ------------------------------------- 
                   list <- list(tt, cpd)
                   return(list)
                 }
               },
               wiki.cpd,
               names(wiki.cpd),
               MoreArgs = list(cpd = unique(sig.df$DATABASE_ID)))
## ------------------------------------- 
hit.freq <- mapply(
                   function(var, n){
                     if(is.list(var))
                       return(n)
                   }, freq, 1:length(freq)) %>% 
  unlist(use.names = F) %>% 
  freq[.]
## ------------------------------------- 
## ------------------------------------- 
# wiki.pw <- names(hit.freq) %>% 
#   stringr::str_extract("^[^\\.]{1,}") %>% 
#   unique()
# ## ------------------------------------- 
# wiki.pw.info <- dplyr::filter(hs.pathways, id %in% all_of(wiki.pw))


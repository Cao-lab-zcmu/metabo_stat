## R
idset <- list.files(path = ".", pattern = "_[0-9]{1,}") %>% 
  stringr::str_extract("[0-9]{1,}$")
## 
meta_dir <- stack_ms2(idset) %>% 
  dplyr::mutate(ms.spec = gsub("spectra/[^/]{1,}$", "spectrum.ms", full.name))
## ---------------------------------------------------------------------- 
spec.list <- pbapply::pbapply(
  meta_dir, 1, function(vec){
    ## read sig spectra
    sig.spec <- read_tsv(vec[["full.name"]])
    ## ------------------------------------- 
    ## read raw spectra
    raw.spec <- readLines(vec[["ms.spec"]])
    return(raw.spec)
  }
)

## MSV000083593 dataset has download
## herein, a metadata table is created to 
## stat these files, and arrange them into 
## groups accordingly.
## ------------------------------------- 
## control, model, samples...
groups <- list.files()
## dataset
dataset <- lapply(groups, list.files, pattern = "ML$") %>% 
  ## each vector in list as df
  lapply(function(vector){
           data.table::data.table(sample = vector)
                  })
names(dataset) <- groups
## as data.table
metadata <- dataset %>% 
  data.table::rbindlist(idcol = T) %>% 
  dplyr::rename(group = .id) %>% 
  ## other attributes supplementation
  dplyr::mutate(`Raw data` = sample,
                path = paste0(group, "/", sample),
                first_seq = stringr::str_extract(sample, "(?<=Plate_)[0-9]{1,}(?=_)"),
                identifier = stringr::str_extract(sample, "(?<=_)[A-Z]{2}[0-9]{1,}(?=_)"),
                ## subgroup
                subgroup = stringr::str_extract(identifier, "[A-Z]{1,}"),
                sufix_seq = stringr::str_extract(sample, "(?<=_)[0-9]{1,}(?=\\.)")) %>%
  dplyr::relocate(`Raw data`)
## write metadata
write.table(metadata, file = "metadata.csv", sep = ",", row.names = F, col.names = T, quote = F)


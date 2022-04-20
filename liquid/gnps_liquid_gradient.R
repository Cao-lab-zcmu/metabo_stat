## Rscript
## for mining more dimentional data, the gradient of 
## liquid phase is considered.
## in order to get reference dataset, firstly, the 
## dataset download from MoNA should be reshape.
metadata_path <- "~/Downloads/msp/MoNA/MoNA-export-GNPS.msp.meta.tsv"
## ------------------------------------- 
metadata <- read_tsv(metadata_path) %>% 
  dplyr::as_tibble()
## -------------------------------------
## positive ion mode is stat first
metadata <- dplyr::filter(metadata, charge == 1)
## ---------------------------------------------------------------------- 
## in previous stat of MCnebula accuracy, dataset which download from
## MSdial website is used. the dataset containing round 8000 compounds.
previous_db <- "~/Downloads/msp/msms_pos_gnps.msp.meta.tsv" %>% 
  read_tsv() %>% 
  dplyr::as_tibble()
## the specific ID in this dataset, that is the GNPS ID, should be collate
previous_db <- previous_db %>% 
  dplyr::mutate(db_entry = stringr::str_extract(Comment, "(?<==)[A-Z]{1,}[0-9]{1,}(?=;)"))
## ---------------------------------------------------------------------- 
## subsequently, the metadata should be filtered according to the db_entry
metadata <- metadata %>% 
  dplyr::filter(`DB#` %in% previous_db$db_entry)
supp <- collate_comment(metadata$Comments)


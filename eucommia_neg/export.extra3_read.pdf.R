## read pdf as string document
lite.bib <- "~/Documents/eucommia.bib"
## ------------------------------------- 
## use package 'bib2df' to parse .bib file
lite.df <-  bib2df::bib2df(lite.bib)
## do filter
lite.df.file <- lite.df %>% 
  ## keep with file
  dplyr::filter(!is.na(FILE))
## ------------------------------------- 
## multi threashold read pdf
pdf_list <- pbapply::pblapply(lite.df.file$FILE,
                              pdftools::pdf_ocr_text,
                              cl = 6)


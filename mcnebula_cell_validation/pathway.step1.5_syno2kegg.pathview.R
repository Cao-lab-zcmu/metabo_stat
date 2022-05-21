## pathview
kegg.syno.from.pub <-
  unlist(syno.from.pub, recursive = F) %>% 
  lapply(
         function(df){
           if(nrow(df) == 0)
             return()
           ## input id type
           in.type <- df$syno.id[1]
           ## exclude kegg
           print(in.type)
           if(in.type == "kegg"){
             ## in line with other
             df$query <- df$syno
             return(df)
           }
           query <- pathview::cpdidmap(df$syno,
                                       in.type = in.type,
                                       out.type = "KEGG")
           df$query <- query[, 2]
           return(df)
         }) %>% 
  data.table::rbindlist() %>% 
  ## filter
  dplyr::filter(!is.na(query))


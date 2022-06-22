## /media/wizard/back/lv
file <- "isomer.xlsx"
## readxl
gather <- data.table::data.table()
list.df <- lapply(2:5,
                  function(sheet){
                    df <- readxl::read_xlsx(file, sheet = sheet, col_names = F)
                    decoy <- df[1,]
                    df <- dplyr::bind_rows(decoy, df)
                    write.table(df, file = paste0("sheet", sheet, ".csv"), na = "",
                                sep = ",", col.names = F, row.names = F, quote = T)
                    ## ------------------------------------- 
                    ## gather
                    if(sheet != 2){
                      m.df <- dplyr::slice(df, -(1:3))
                    }else{
                      m.df <- df
                    }
                    gather <- dplyr::bind_rows(gather, m.df)
                    assign("gather", gather, envir = parent.frame(2))
                    ## ------------------------------------- 
                    df <- dplyr::select(df, 1:2) %>% 
                      dplyr::filter(!is.na(...1))
                    return(df)
                  })
gather <- dplyr::mutate(gather, ...1 = ifelse(is.na(...1), ...1, as.numeric(rownames(gather))-3),
                        ...2 = ifelse(is.na(...2), ...2, ""))
write.table(gather, file = paste0("gather.csv"), na = "",
            sep = ",", col.names = F, row.names = F, quote = T)
## ------------------------------------- 
df.no.g <- dplyr::filter(gather, !is.na(...1)) %>% 
  dplyr::as_tibble() %>% 
  dplyr::select(1:2)
list.df <- c(list(df.no.g), list.df)
## ------------------------------------- 
file_set <- list.files(pattern = "csv$")
## ------------------------------------- 
file.list <- mapply(
                    function(file, df.no){
                      ## get data
                      df <- qi_get_format(file)
                      ## add 1 and log2
                      if(grepl("gather", file)){
                        df <- dplyr::summarise_all(df, function(vec)log2(vec + 1)) %>% 
                          as_tibble()
                      }else{
                        df <- dplyr::summarise_all(df, function(vec)log2(vec + 1)) %>% 
                          as_tibble()
                      }
                      ## rename df.no
                      colnames(df.no) <- c("No.", "name")
                      df <- dplyr::bind_cols(df.no, df) %>% 
                        dplyr::mutate(no.name = paste0("No.", No., ":",
                                                       ifelse(is.na(name), "", name)),
                                      no.name = stringr::str_wrap(no.name, 30))
                      ## ---------------------------------------------------------------------- 
                      ## as long df
                      df.long <- df %>% 
                        reshape2::melt(id.vars = c("No.", "name", "no.name"),
                                       variable.name = "sample", value.name = "value") %>% 
                        dplyr::mutate(value = value - (max(value, na.rm = T) - min(value, na.rm = T)) / 2) %>% 
                        dplyr::as_tibble() %>% 
                        dplyr::filter(!is.na(value))
                      ## ------------------------------------- 
                      p <- dot_heatmap(df.long)
                      ## ---------------------------------------------------------------------- 
                      ## the non_exclude
                      in.row <- df.long$no.name %>% 
                        unique()
                      ## oringal data.frame
                      mutate.df <- df.long %>% 
                        tidyr::spread(key = sample, value = value) %>% 
                        dplyr::filter(no.name %in% all_of(in.row)) %>% 
                        data.frame()
                      row.names(mutate.df) <- mutate.df$no.name
                      mutate.df <- dplyr::select(mutate.df, contains("_"))
                      p <- add_tree.heatmap(mutate.df, p, phc.height = ifelse(grepl("gather", file), 0.1, 0.3))
                      ## ---------------------------------------------------------------------- 
                      meta <- qi_get_format(file, metadata = T)
                      ## ------------------------------------- 
                      p <- add_xgroup.heatmap(meta, p)
                      ## ---------------------------------------------------------------------- 
                      ## save
                      file.s <- paste0(file, ".svg")
                      if(grepl("gather", file)){
                        height <- 25
                      }else{
                        height = 14
                      }
                      ggsave(p, filename = file.s, width = 8, height = height)
                      ## png
                      rsvg::rsvg_png(file.s, paste0(file, ".png"), width = 5000)
                      return()
                    },
                    file_set, list.df, SIMPLIFY = F)


## ------------------------------------- 
## draw legend of pathway
## ------------------------------------- 
## exclude 
ex <- c("hsa04979", "hsa04216", "hsa04142")
df.or <- dplyr::mutate(nodes, NAME = gsub(" - Homo sapiens \\(human\\)", "", NAME)) %>% 
  dplyr::filter(grepl("hsa", name)) %>% 
  dplyr::arrange(NAME)
## ------------------------------------- 
df <- df.or %>% 
  dplyr::filter(!name %in% all_of(ex)) 
GROUP <- rownames(df) %>% 
  grouping_vec2list(round(nrow(df) / 3), T)
x <- mapply(function(x, y){rep(x, y)}, 1:length(GROUP), lengths(GROUP)) %>% 
  unlist()
df <- dplyr::mutate(df, x = x)
## ------------------ 
list <- by_group_as_list(df, "x")
tmp <- lapply(list, nrow) %>% 
  unlist()
if(max(tmp) != min(tmp)){
  n <- which(tmp == min(tmp))
  list[[n]] <- dplyr::bind_rows(list[[n]],
                                data.table::data.table(NAME = rep(NA, max(tmp) - min(tmp)))) %>% 
    dplyr::mutate(NAME = ifelse(is.na(NAME), "", NAME),
                  x = x)
}
## ------------------------------------- 
df <- dplyr::filter(df.or, name %in% all_of(ex)) %>% 
  dplyr::mutate(x = 100) %>% 
  dplyr::bind_rows(., data.table::data.table(NAME = rep(NA, max(tmp) - nrow(.)))) %>% 
  dplyr::mutate(NAME = ifelse(is.na(NAME),
                              sapply(1:nrow(.), function(x){paste0(rep(" ", x), collapse = "")}),
                              NAME),
                x = 100)
list <- c(list, list(df))
lapply(list, function(df){
         df <- dplyr::mutate(df,
                             NAME = factor(NAME,
                                           levels = c(NAME[which(grepl("^ |^$", NAME))],
                                                      rev(sort(NAME[which(!grepl("^ |^$", NAME))])))
                                           ))
         p <- ggplot(df,
                     aes(x = x, y = NAME, label = NAME)) +
            geom_text(family = "Times", hjust = 0, size = 5) +
            xlim(c(df[1, ]$x, df[1, ]$x + 1)) +
            theme_void() +
            theme(axis.text = element_blank(), 
                  panel.grid = element_blank(),
                  panel.border = element_blank(),
                  panel.spacing = element_blank()
            )
          ggsave(p, file = paste0("legend", df[1, ]$x, ".svg"), width = 4.5, height = 4)
                })


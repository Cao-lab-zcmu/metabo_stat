## reshape as long data.table
heat.norm.df.l <- reshape2::melt(heat.norm.df,
                                 id.vars = c("origin_id", ".id"),
                                 value.name = "value", variable.name = "sample")
## 0 as info
min <- min(dplyr::filter(heat.norm.df.l, value != 0)$value)
## log2
heat.norm.df.l <- dplyr::as_tibble(heat.norm.df.l) %>% 
  dplyr::mutate(value = ifelse(value == 0, min / 10, value),
                value = log2(value),
                value = scale(value, scale = F)) %>% 
  dplyr::rename(no.name = .id)
 
## tile heatmap
p <- tile_heatmap(heat.norm.df.l)
 
## classify
 
p <- do.call(
             function(df, p){
               df <- dplyr::rename(df, class = name, no.name = .id) %>% 
                 dplyr::filter(no.name %in% all_of(unique(heat.norm.df.l$no.name)))
               ## ------------------------------------- 
               class <- c("Acyl carnitines",
                          "Lysophosphatidylcholines",
                          "Bile acids, alcohols and derivatives")
               pal <- ggsci::pal_futurama()(3)
               names(pal) <- class
               pal <- pal[names(pal) %in% heat.class]
               ## ------------------------------------- 
               p <- add_ygroup.tile.heatmap(df, p, pal)
               return(p)
             }, list(df = heat.index, p = p)
)
 
## add tree
 
heat.norm.df.w <- tidyr::spread(heat.norm.df.l, key = sample, value = value) %>% 
  ## format for hclust
  data.frame()
rownames(heat.norm.df.w) <- heat.norm.df.w$no.name
heat.norm.df.w <- heat.norm.df.w %>% 
  dplyr::select(-1, -2)
 
p <- add_tree.heatmap(heat.norm.df.w, p)
 
## sample group
 
p <- do.call(
             function(df, p, pal){
               df <- dplyr::rename(df,
                                   full.group = group,
                                   group = subgroup,
                                   sample = name)
               p <- add_xgroup.tile.heatmap(df, p, pal)
               return(p)
             }, list(df = meta_feature_stat,
                     p = p, pal = stat_palette))


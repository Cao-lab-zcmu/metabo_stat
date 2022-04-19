## stat variation relativa abundance
## gather data
var_rel.abund <- list(tmp_nebula_index, .MCn.nebula_index) %>% 
  lapply(function(df){
           df <- table(df$name) %>% 
             data.table::data.table() %>% 
             dplyr::rename(class = V1, abund = N)
           return(df)
                }) 
## stat rel.adund
var_rel.abund <- merge(var_rel.abund[[1]], var_rel.abund[[2]], by = "class", all.x = T) %>% 
  dplyr::mutate(rel.abund = abund.x / abund.y)
## ------------------------------------- 
generic_horizon_bar(df = dplyr::select(df, class, rel.abund),
                    xlab = "classification",
                    ylab = "variation relative abundance",
                    save = "mcnebula_results/trace/rank.svg")
## ------------------------------------- 
# main <- read_svg("mcnebula_results/trace/stru_child_nebulae.svg", as_cairo = F)
# legend <- read_svg("mcnebula_results/trace/rank.svg")
# ## ------------------ 
# grid_draw_svg.legend(main, legend,
#                      width = 16,
#                      position.main = 0.7,
                     # savename = "mcnebula_results/trace/merge_gradient.svg")



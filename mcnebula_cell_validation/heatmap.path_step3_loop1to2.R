## ------------------------------------- 
heat.class <- c(
                "Acyl carnitines",
                "Lysophosphatidylcholines",
                "Bile acids, alcohols and derivatives")
## ---------------------------------------------------------------------- 
mapply(
       function(heat.class, short.name){
         cat("## Processing class", heat.class, "\n")
         source("~/outline/mcnebula_cell_validation/heatmap.path_step1_df.prep.R",
                local = T)
         source("~/outline/mcnebula_cell_validation/heatmap.path_step2_draw.R",
                local = T)
         ggsave(p, filename = paste0(short.name, ".svg"),  height = 10, width = 35)
         rsvg::rsvg_png(paste0(short.name, ".svg"), paste0(short.name, ".png"), width = 10000)
       }, heat.class, c("ac", "lpc", "ba"))
## ---------------------------------------------------------------------- 

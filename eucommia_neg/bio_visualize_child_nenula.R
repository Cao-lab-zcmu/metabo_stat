## ---------------------------------------------------------------------- 
## for tracing compounds
## set df to mark efs25 nodes
mark_df <- data.table::data.table(.id = paste0(log.fc_stat$.id), mark = log.fc_stat$log2fc)
## set mark_palette
mark_palette <- c("#FED439FF", "#709AE1FF")
names(mark_palette) <- c("10 times FC", "Others")
## visualize_child_nebulae
fill_expression <- "scale_fill_gradient2(low = 'blue', high = 'red', mid = 'white', midpoint = 0)"
visualize_child_nebulae(output = "mcnebula_results/trace",
                        nodes_mark = mark_df,
                        scale_fill_expression = fill_expression,
                        remove_legend_lab = T,
                        legend_fill = T,
                        legend_position = "bottom",
                        width = 15, height = 20)
file.rename("mcnebula_results/trace/child_nebulae.svg", "mcnebula_results/trace/gradient_nebula.svg")
## ---------------------------------------------------------------------- 
visualize_child_nebulae(output = "mcnebula_results/trace",
                        width = 15, height = 20)
file.rename("mcnebula_results/trace/child_nebulae.svg", "mcnebula_results/trace/struc_nebula.svg")
## ---------------------------------------------------------------------- 
## ---------------------------------------------------------------------- 
## visualize legend for nebula-index
label_palette <- .MCn.palette_label[3:6]
names(label_palette) <- Hmisc::capitalize(c("level 5", "subclass", "class", "superclass"))[4:1]
mutate_show_palette(label_palette, font_size = 25,
             width = 3,
             title = "",
             fill_lab = "Class-Hierarchy",
             xlab = "", ylab = "", re_order = F)


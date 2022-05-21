## draw ggraph
set.seed(100)
layout_n <- ggraph::create_layout(tidy.graph, layout = "graphopt")
## palette
gra.pal <- ggsci::pal_npg()(9)
## draw
p <- ggraph(layout_n) + 
  geom_edge_fan(aes(edge_width = weight),
                color = "black",
                show.legend = F,
                arrow = arrow(length = unit(2, 'mm'))) + 
  geom_node_point(aes(color = type,
                      shape = input_compound,
                      size = type),
                  stroke = 0.1) + 
  geom_node_text(aes(label = ifelse(type != "Reaction",
                                    abb.name,
                                    "")),
                 size = 2,
                 family = "Times",
                 color = "black") +
  scale_shape_manual(values = c(`Input compound` = 15, `Others` = 16)) +
  scale_color_manual(values = c(Pathway = gra.pal[1],
                                Module = "#E377C2",
                                Enzyme = "#EFC000",
                                Reaction = gra.pal[2],
                                Compound = gra.pal[3])) +
  scale_size_manual(values = c(Pathway = 7,
                               Module = 5,
                               Enzyme = 6,
                               Reaction = 5,
                               Compound = 10)) +
  scale_edge_width(range = c(0.1, 0.3)) + 
  guides(size = "none",
         shape = guide_legend(override.aes = list(size = 4)),
         color = guide_legend(override.aes = list(size = 4))) +
  # scale_color_manual(values = palette) +
  # guides(color = guide_legend(override.aes = list(size = 8))) +
  labs(color = "Category", shape = "Type") +
  theme_grey() +
  theme(text = element_text(family = "Times"),
        axis.ticks = element_blank(),
        axis.text = element_blank(),
        axis.title = element_blank(),
        panel.background = element_rect(fill = "white"), 
        # axis.line = element_blank(),
        # legend.key.width = unit(1, "cm"),
        # legend.key.height = unit(1, "cm"),
        legend.title = element_text(face = "bold", hjust = 0.2, family = "Times"),
        legend.text = element_text(family = "Times"),
        legend.background = element_rect(fill = "transparent"),
        # legend.position = c(0.6,0.25),
        panel.grid = element_blank(),
        strip.text = element_text(face = "bold")
  )
  ## ------------------------------------- 
  ggsave(p, file = "pathway.gg.svg", width = 11, height = 9)
  ## as png graph
  rsvg::rsvg_png("pathway.gg.svg", "pathway/pathway.png", width = 5000)

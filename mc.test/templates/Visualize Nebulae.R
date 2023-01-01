s5 <- new_heading("Visualize Nebulae", 2)

s5.1 <- new_section2(
  c("Create layouts for Parent-Nebula or Child-Nebulae visualizations."),
  rblock({
    mcn <- create_parent_layout(mcn)
    mcn <- create_child_layouts(mcn)
    mcn <- activate_nebulae(mcn)
  })
)

s5.3 <- new_section2(
  c("The available chemical classes for visualization and its",
    "sequence in storage."),
  rblock({
    table.nebulae <- visualize(mcn)
    table.nebulae
  }, args = list(eval = T))
)

s5.6 <- new_section2(
  c("Draw and save as .png or .pdf image files."),
  rblock({
    p <- visualize(mcn, "parent")
    ggsave(f5.61 <- paste0(tmp, "/parent_nebula.png"), p)
    pdf(f5.62 <- paste0(tmp, "/child_nebula.pdf"), 12, 14)
    visualize_all(mcn)
    dev.off()
  })
)

s5.6.fig1 <- include_figure(f5.61, "parent", "Parent-Nebula")
s5.6.fig2 <- include_figure(f5.62, "child", "Child-Nebulae")

ref <- function(x) {
  paste0("(Fig. ", get_ref(x), ")")
}

s5.8 <- c(
  "In general, Parent-Nebulae", ref(s5.6.fig1),
  "is too informative to show, so Child-Nebulae", ref(s5.6.fig2),
  "was used to dipict the abundant classes of features (metabolites)",
  "in a grid panel, intuitively. In a bird's eye view of",
  "Child-Nebulae, we can obtain many characteristics of features,",
  "involving classes distribution, structure identified accuracy, as",
  "well as spectral similarity within classes."
)

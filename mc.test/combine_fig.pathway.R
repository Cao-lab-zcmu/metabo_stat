# ==========================================================================
# combine 3 figures of png of pathway enrichment
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
pngs <- list.files(pattern = "pathway.*\\.png")
pngs <- lapply(pngs, png::readPNG)
names(pngs) <- c("ACs", "BAs", "LPCs")

pngs <- lapply(pngs,
  function(png) {
    grid.grabExpr(grid.raster(png))
  })

grobs <- lapply(1:3,
  function(n, x = c("a", "b", "c")) {
    into(grecta(x[n], cex = 3), pngs[[ n ]])
  })
names(grobs) <- names(pngs)

grobs.path <- frame_row(c(ACs = 1, BAs = 1, LPCs = 1), grobs)
grobs.path <- ggather(grobs.path, vp = viewport(, , .95, .95))

pdf("pathway.pdf", 7, 7)
draw(grobs.path)
dev.off()


## codes
tmp <- paste0(tempdir(), "/test.pdf")
pdf(tmp)
plot(1:10)
dev.off()

fig_block <- include_figure(
  tmp, "plot", "This is caption"
)
fig_block

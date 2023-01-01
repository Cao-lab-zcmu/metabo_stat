
## codes
s1 <- new_heading("Title 1", 1)

s1.5 <- new_section2(
  c("..."), NULL
)

s2 <- new_section2(
  c("This is sentence 1.",
    "This is sentence 2.",
    "This is sentence 3."),
  rblock({
    df <- data.frame(x = 1:10, y = 1:10)
    df <- dplyr::mutate(df,
      group = rep(paste0("p", 1:3), c(3, 3, 4))
    )
  })
)

s3 <- new_heading("Title 2", 1)

s4 <- new_section2(
  c("This is a paragraph..."),
  rblock({
    p <- ggplot(df) +
      geom_point(aes(x = x, y = y, fill = group))
    ggsave(f <- paste0(tempdir(), "/test.pdf"), p)
  })
)

s5 <- include_figure(f, "name", "Caption: ...")

s6 <- rblock({
  print(1:100)
}, args = list(echo = F, eval = F))

s7 <- c("... paragraph ...")

sections <- gather_sections()
report <- do.call(new_report, sections)
render_report(report, paste0(tempdir(), "/report.Rmd"), T)

####################
##### Another example
####################

h1 <- new_heading("heading, level 1", 1)

sec1 <- new_section(
  "sub-heading", 2,
  "This is a description.",
  new_code_block(codes = "seq <- lapply(1:10, cat)")
)

h2 <- new_heading("heading 2, level 1", 1)

fig_block <- new_code_block_figure("plot", "this is a caption",
  codes = "df <- data.frame(x = 1:10, y = 1:10)
    p <- ggplot(df) +
      geom_point(aes(x = x, y = y))
    p"
)
sec2 <- new_section(
  "sub-heading2", 2,
  paste0(
    "This is a description. ",
    "See Figure ", get_ref(fig_block), "."
  ),
  fig_block
)

a_data <- dplyr::storms[1:15, 1:10]
table_block <- include_table(a_data, "table1", "This is a caption")

sec3 <- new_section(
  NULL, ,
  paste0("See Table ", get_ref(table_block, "tab"), "."),
  NULL
)

tmp_p <- paste0(tempdir(), "/test.pdf")
pdf(tmp_p)
plot(1:10)
dev.off()
fig_block_2 <- include_figure(tmp_p, "plot2", "this is a caption")
sec4 <- history_rblock(, "^tmp_p <- ", "^fig_block_2")
sec4

## gather
yaml <- "title: 'title'\noutput:\n  bookdown::pdf_document2"
report <- new_report(
  h1, sec1, h2, sec2,
  table_block, sec3,
  fig_block_2, sec4,
  yaml = yaml
)
report

## output
tmp <- paste0(tempdir(), "/tmp_output.Rmd")
render_report(report, tmp)
rmarkdown::render(tmp)
file.exists(sub("Rmd$", "pdf", tmp))

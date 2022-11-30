
## codes
## ------------------------------------- 
## heading
new_heading("this is a heading", 2)

## ------------------------------------- 
## section
## example 1
para <- "This is a paragraph stating"
section <- new_section("this is a heading", 2, para)
## see results
section
call_command(section)
writeLines(call_command(section))

## example 2
para <- "This is a paragraph stating"
section <- new_section(NULL, , para, NULL)

## example 3
para <- "This is a paragraph stating"
block <- new_code_block(codes = "df <- data.frame(x = 1:10)")
section <- new_section("heading", 2, para, block)
section

## example 4
codes <- "df <- data.frame(x = 1:10, y = 1:10)
  p <- ggplot(df) +
    geom_point(aes(x = x, y = y))
  p"
fig_block <- new_code_block_figure("plot", "this is caption", codes = codes)
para <- paste0("This is a paragraph describing the picture. ",
               "See Figure ", get_ref(fig_block), ".")
section <- new_section("heading", 2, para, fig_block)
section
## output
tmp <- paste0(tempdir(), "/tmp_output.Rmd")
writeLines(call_command(section), tmp)
rmarkdown::render(tmp, output_format = "bookdown::pdf_document2")
file.exists(sub("Rmd$", "pdf", tmp))
## see [report-class] object: 
## A complete output report, including multiple 'section'.

## defalt parameters
new_section()

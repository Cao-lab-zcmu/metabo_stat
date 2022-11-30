
## codes
## general
codes <- "df <- data.frame(x = 1:10)
  df<-dplyr::mutate(df,y=x*1.5)%>%
  dplyr::filter(x >= 5)
  p <- ggplot(df)+
  geom_point(aes(x=x,y=y))
  p"
block <- new_code_block("r", codes, list(eval = T, echo = T, message = T))
## see results
block
call_command(block)
writeLines(call_command(block))

## figure
fig_block <- new_code_block_figure(
  "plot1",
  "this is a caption",
  codes = codes
)
## see results
fig_block
writeLines(call_command(fig_block))
command_args(fig_block)
cat(get_ref(fig_block), "\n")

## table
codes <- "df <- data.frame(x = 1:10) %>% 
  dplyr::mutate(y = x, z = x * y)
  knitr::kable(df, format = 'markdown', caption = 'this is a caption') "
tab_block <- new_code_block_table("table1", codes = codes)
## see results
tab_block
cat(get_ref(tab_block), "\n")

## default parameters
new_code_block()


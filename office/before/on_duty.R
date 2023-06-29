## R
## ------------------------------------- 
## ========== Run block ========== 
title <- "Staff on duty and arrangement"
subtitle <- ""
footnote <- "Test"
start <- Sys.Date()
span <- 7
span.number <- 4
cycle <- 7
entry <- c(
           "Indoor Hygiene",
           "Supplies replenishment",
           "Endotube cleaning",
           "Ion source cleaning"
)
staff <- paste0("test", 1:10)
## ------------------------------------- 
df <- data.table::data.table(
    coeff = 0:(span.number * cycle - 1)
  ) %>% 
  dplyr::mutate(
    from = coeff * span,
    from = start + from,
    ## year
    annual = stringr::str_extract(from, "^[0-9]{1,}"),
    ## as character
    from = gsub("^[0-9]{1,}-", "", from),
    ## the same...
    to = (span - 1) + coeff * span,
    to = start + to,
    to = gsub("^[0-9]{1,}-", "", to)
  )
## ------------------------------------- 
entry.x <- rep("", length(entry)) %>% 
  lapply(c)
## args name
names(entry.x) <- entry
## args of data.table
entry.x$.data <- df
## do mutate
mut.df <- do.call(dplyr::mutate, entry.x)
## ------------------------------------- 
staff <- staff[1:cycle]
## add staff
mut.df <- dplyr::mutate(
  mut.df,
  staff = rep(staff, rep(span.number, cycle))
)
## ------------------------------------- 
export <- dplyr::select(mut.df, -coeff) %>% 
  dplyr::relocate(annual, from, to, staff) %>% 
  dplyr::rename(`Date#From` = from, `Date#To` = to, Annual = annual) %>% 
  dplyr::as_tibble() %>% 
  dplyr::group_by(staff)
colnames(export) <- colnames(export) %>% 
  mapply_rename_col(entry, paste0("Entry#", entry), .)
## ------------------------------------- 
## ========== Run block ========== 
sep.col <- colnames(export) %>% 
  .[grepl("#", .)]
## fill as gray
fill.col <- colnames(export) %>% 
  .[!grepl("staff|Annual|From|To$", .)] %>% 
  .[seq(1, length(.), by = 2)]
# spec.row <- seq(1, nrow(export), by = 4) %>% 
#   c(., . + 1) %>% 
#   sort()
# ex.spec.row <- 1:nrow(export) %>% 
  # .[!. %in% spec.row]
## table
gt_table <- gt(export) %>% 
  gtExtras::gt_theme_guardian() %>% 
  opt_table_font(font = list("Times New Roman")) %>% 
  tab_header(title = md(title), subtitle = md(subtitle)) %>% 
  tab_footnote(footnote = footnote,
               locations = cells_title(groups = c("title"))) %>% 
  tab_spanner_delim(columns = all_of(sep.col), delim = "#") %>% 
  tab_style(style = cell_text(align = "center",
                              weight = "bold"),
            locations = cells_row_groups(groups = everything())
  ) %>% 
  tab_style(style = cell_borders(sides = c("top", "bottom"),
                                    color = "grey",
                                    weight = px(1),
                                    style = "solid"),
            locations = cells_row_groups(groups = everything())
  ) %>% 
  tab_style(style = cell_fill(color = "gray92"),
            locations = cells_body(columns = all_of(fill.col),
                                   rows = seq(1, nrow(export), by = 2))
  ) %>% 
  tab_style(style = cell_fill(color = "gray96"),
            locations = cells_body(columns = all_of(fill.col),
                                   rows = seq(2, nrow(export) + 1, by = 2))
  ) %>% 
  tab_style(style = cell_fill(color = "gray92"),
                   locations = cells_column_labels(columns = all_of(fill.col))
  ) 
#   tab_style(style = cell_fill(color = "gray92"),
  #           locations = cells_body(columns = `Entry#Ion source cleaning`,
  #                                  rows = spec.row)
  # ) %>% 
  # tab_style(style = cell_fill(color = "gray96"),
  #           locations = cells_body(columns = `Entry#Ion source cleaning`,
  #                                  rows = ex.spec.row)
  # )

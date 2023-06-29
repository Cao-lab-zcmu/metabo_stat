# ==========================================================================
# (copy from "../mc.test/site_mcnebula2.R")
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

devtools::load_all("~/utils.tool")
options(blogdown.method = "markdown")
setwd("~/siteBlog/")
blogdown::serve_site()
set_hugoDir("~/siteBlog")
# blogdown::stop_server()

new_notes(c("bioinformatics"), 1000)
new_notes(c("usefull_tools"), 1001)

# ==========================================================================
# create scene
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

new_scene(c(prologue = "introduction"), rep(110, 1), c(100))

new_scene(c(novel = "white_heart_breath"), rep(500, 1), c(510))

# ==========================================================================
# contact and about
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# ==========================================================================
# basic setting (text)
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

description <- paste0(strwrap("Personal website that records notes, essays and novels."),
    collapse = " ")
addition <- "Documentation of Shaman Yellow"

set_home(c(title = "Secret Bases",
           titleSeparator = " | ",
           titleAddition = addition,
           description = description))

set_index(c(title = paste0(addition),
            lead = description,
            date = record_time(),
            lastmod = record_time()),
          "en/_index.Rmd"
)



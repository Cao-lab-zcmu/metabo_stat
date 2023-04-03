
# install.packages("blogdown")
setwd("~/MCnebula2/")

# web_config <- readLines(file <- "config/production/config.toml")
# web_config[2] <- "baseURL = 'https://mcnebula.netlify.app'"
# writeLines(web_config, file)

options(blogdown.method = "markdown")
blogdown::serve_site()
# blogdown::stop_server()

devtools::load_all("~/utils.tool")

description <- paste0(strwrap("Critical chemical classes to classify and boost
    identification by visualization for untargeted LC-MS/MS data analysis"),
    collapse = " ")
addition <- "R package for analysis of non-targeted LC-MS/MS"

# ==========================================================================
# basic setting (text)
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

set_home(c(title = "MCnebula2",
           titleSeparator = " | ",
           titleAddition = addition,
           description = description))

set_index(c(title = paste0("MCnebula2: ", addition),
            lead = description,
            date = record_time(),
            lastmod = record_time()),
          "en/_index.Rmd"
)

# ==========================================================================
# create scene
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

new_scene(c(prologue = "introduction",
    prologue = "super_quick_start",
    prologue = "quick_start",
    prologue = "usage"),
  rep(110, 4), c(100, 40, 50, 110))

new_scene(c(installation = "linux",
            installation = "windows",
            installation = "macOS"),
          rep(100, 3), c(10, 20, 30))

new_scene(c(recommendation = "mzmine2",
            recommendation = "sirius_4",
            recommendation = "proteowizard"),
          rep(200, 3), c(220, 230, 210))

new_scene(c(workflow = "basic_workflow"), 150)
new_scene(c(workflow = "metabolic_workflow"), 152)
new_scene(c(workflow = "chemical_workflow"), 153)

new_scene(c(herbal_eucommia = "index",
            metabolites_serum = "index"),
          rep(500, 3), c(100, 200), tar = "news", index_Draft = F)

new_scene(c(help = "R_tips"), 5000)

# ==========================================================================
# contact and about
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

new_scene(c(contact = "index"), 1000, 1100, tar = "en", index_Draft = F)
new_scene(c(about = "index"), 2000, 2100, tar = "en", index_Draft = F)



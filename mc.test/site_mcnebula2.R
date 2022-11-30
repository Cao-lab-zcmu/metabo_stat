
# install.packages("blogdown")
setwd("~/MCnebula2/")
library(MCnebula2)
blogdown::serve_site()
blogdown::stop_server()

devtools::load_all("~/utils.tool")

description <- paste0(strwrap("MCnebula workflow, for metabolic dataset analysis,
  involving: feature detection, compound identification based on MS/MS (in silico),
  statistical analysis, compound structure and chemical class focusing,
  multi-dimensional visualization, output report, etc."), collapse = " ")

addition <- "analysis of LC-MS/MS metabolomics"

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

new_scene(c(installation = "linux",
            installation = "windows",
            installation = "macOS"),
          rep(110, 3), c(100, 200, 150))

new_scene(c(recommendation = "mzmine2",
            recommendation = "sirius_4",
            recommendation = "proteowizard"),
          rep(200, 3), c(100, 200, 50))

new_scene(c(workflow = "basic_workflow"), 150)



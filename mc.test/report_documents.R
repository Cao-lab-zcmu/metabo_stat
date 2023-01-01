# ==========================================================================
# Description of the preset
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

reportDoc <-
  list(introduction = readLines("~/Documents/mcnebula2/introduction.Rmd"),
       setup = readLines("~/Documents/mcnebula2/setup.Rmd"),
       abstract = readLines("~/Documents/mcnebula2/abstract.Rmd"),
       filter = readLines("~/Documents/mcnebula2/filter.Rmd"),
       stardust = readLines("~/Documents/mcnebula2/stardust.Rmd"),
       nebulae = readLines("~/Documents/mcnebula2/nebulae.Rmd"),
       statistic = readLines("~/Documents/mcnebula2/statistic.Rmd"),
       tracer = readLines("~/Documents/mcnebula2/tracer.Rmd"),
       annotate = readLines("~/Documents/mcnebula2/annotate.Rmd")
  )

# usethis::use_data(reportDoc)


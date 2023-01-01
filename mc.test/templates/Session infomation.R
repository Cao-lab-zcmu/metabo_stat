s100 <- new_heading("Session infomation", 1)

s100.1 <- rblock({
  sessionInfo()
}, args = list(eval = T))

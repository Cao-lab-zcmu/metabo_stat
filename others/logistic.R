## ------------------------------------- 
## ========== Run block ========== 
fun_curve <- 
  function(
           x,
           a = -1,
           b = 5
           ){
    y1 <- a + b * x
    y <- exp(y1) / (1 + exp(y1))
    data.table(x = x, y = y)
  }
## ------------------------------------- 
## ========== Run block ========== 
test <- lapply(c(10, 1, 0.1, 0.001), function(value){
         test <- fun_curve(-10:20, b = value) %>% 
           dplyr::mutate(rank = value)
           }) %>% 
  data.table::rbindlist()
test_p <- get_facet_line(test)

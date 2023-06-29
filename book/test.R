
x <- "test"

test <- 1
test1 <- "1"

test1 <- "test that \" '"
test1 <- 'test that \"\"'
test <- 1 + 1

test <- test + test + test

df <- data.frame(x = 1:10, y = 10:1)
df$x
df$y
df$z <- 1:10

dplyr::mutate(df, b = 1:10, i = 1:10 * 100, p = 1:10 / 199 * 777, bb = paste0(1:10, 10:1))

x <- 1:10
x > 5


x <- 10:1 + 10

df[df$x > 15, ]
df[!duplicated(df$x), ]

dplyr::filter(df, !!x > 15)
dplyr::mutate
dplyr::select(df, x, y)
dplyr::arrange(df, dplyr::desc(
 y))
df2 <- rbind(df, df)
df3 <- cbind(df, df)
dplyr::distinct(df2, x, y, .keep_all = T)
dplyr::summrise()

dplyr::mutate(df, x = paste0(x * 10, "gg"))

data.table::fwrite(mtcars, "test.csv")

t <- data.table::fread("test.csv")
t.test(t$mpg, t$cyl)$p.value

t <- list(x = 1, y = 2, z = data.frame(x = 1:10, y = 1:10))
t$z$x <- t$z$x + 10
t$z$x %<>% `+`(., 10)

df %>% 
  dplyr::filter(., x > 5) %>% 
  dplyr::mutate(z = x) %>% 
  dplyr::select(y)

x <- 1
y <- 2
z <- rep(x + y * 10, 10)

fun <- function(x, y, ...) {
  z <- rep(x + y * 10, 10)
  z
}

mtcars

library(ggplot2)

fun <- function(data, color = "lightblue", y = .7, uuuuu, ioiiii) {
  u <- 1
  p <- ggplot(data) +
    geom_col(aes(x = mpg, y = cyl), color = color, width = y) +
    theme(text = element_text(family = "Arial"))
  return(p)
}

p2 <- fun(mtcars)


gsub("^t", 999, "testest")
stringr::str_extract("8testuuu2testuuu1", "(?<=u)[0-9](?=t)")


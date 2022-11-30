
## codes
data <- data.frame(x = 1:10, y = 1:10)
layer1 <- new_command(ggplot, data)
layer2 <- new_command(geom_point, aes(x = x, y = y))
layer3 <- new_command(labs, x = "x label", y = "y label")
layer4 <- new_command(theme, text = element_text(family = "Times"))

## gather
ggset <- new_ggset(layer1, layer2, layer3, layer4)
ggset
## visualize
p <- call_command(ggset)
p

## add layers
layer5 <- new_command(
  geom_text,
  aes(x = x, y = y, label = paste0("label_", x))
)
layer6 <- new_command(ggtitle, "this is title")
ggset <- add_layers(ggset, layer5, layer6)
call_command(ggset)

## delete layers
ggset <- delete_layers(ggset, 5:6)
call_command(ggset)

## mutate layer
ggset <- mutate_layer(ggset, "theme",
  legend.position = "none",
  plot.background = element_rect(fill = "red")
)
ggset <- mutate_layer(ggset, "geom_point",
  mapping = aes(x = x, y = y, color = x)
)
call_command(ggset)

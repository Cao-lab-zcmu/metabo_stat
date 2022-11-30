
## codes
## example 1
com <- new_command(plot, x = 1:10)
com
call_command(com)

## example 2
com <- new_command(data.frame, x = 1:10, y = 1:10, z = 1:10)
call_command(com)

## example 3
data <- data.frame(x = 1:10, y = 1:10)
com1 <- new_command(ggplot, data)
com2 <- new_command(geom_point, aes(x = x, y = y))
call_command(com1) + call_command(com2)

## slots
command_name(com)
command_args(com)
command_function(com)

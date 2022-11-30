
tmp <- paste0(tempdir(), "/test.png")

png(tmp, 480, 490)
pushViewport(viewport(, , 0.5, 0.5))
test <- grecto("test", cex = 3)
draw(test, gtext("shiny", list(cex = 5)))
dev.off()

cv <- import("cv2")
# np <- import("numpy")

img <- cv$imread(tmp)

dim <- dim(img)[1:2]
w <- dim[1]
h <- dim[2]

src <- rbind(c(0, 0), c(0, h), c(w, 0), c(w, h))
target <- rbind(c(100, 100), c(0, h), c(300, 100), c(w, h))

trans <- cv$findHomography(src, target)[[1]]

new_img <- cv$warpPerspective(img, trans, dim)


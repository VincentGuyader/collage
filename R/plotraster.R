# -*- coding: utf-8 -*-
#' @encoding UTF-8
#' @title plotraster
#' @description affiche une image raster dans la fenêtre graphique
#' @param img l 'image (en array)
#' @param verbose booleen qui rend la fonction bavarde
#' @export


plotraster <- function(img, verbose = TRUE) {
    # print('on plot')
  img <- aperm(img, c(2, 1, 3))
    ydim <- attributes(img)$dim[1]  # Image dimension y-axis
    xdim <- attributes(img)$dim[2]  # Image dimension x-axis
    par(bg = "white")
    plot(c(0, xdim), c(0, ydim), type = "n", xlab = "", ylab = "", bty = "n", axes = FALSE)
    if (verbose) {
        message(paste("        masque OK "))
    }
    img[img > 1] <- 1
    img[img < 0] <- 0
    rasterImage(img, 0, 0, xdim, ydim)
    if (verbose) {
        message(paste("        plot OK "))
    }
}

#' plotraster
#'
#' affiche une image raster dans la fenêtre graphique
#' @param img l 'image (en array)
#' @param verbose booleen qui rend la fonction bavarde
#' @importFrom graphics rasterImage par plot
#' @export
plotraster <- function(img, verbose = TRUE) {
    width <- ncol(img)
    height <- nrow(img)
    par(bg = "white", mar = c(.5,.5,.5,.5))

    plot(xlim = c(0, width), ylim = c(0, height), type = "n", xlab = "", ylab = "", bty = "n", axes = FALSE)
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

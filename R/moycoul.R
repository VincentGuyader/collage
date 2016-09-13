# -*- coding: utf-8 -*-
#' @encoding UTF-8
#' @title moycoul
#' @description renvoi le code RVB et html moyen d'une image
#' @param img l'image (en array)
#' @importFrom grDevices rgb
#' @export
moycoul <- function(img) {
    if (is.null(dim(img))) {
        val <- img
    } else {
        val <- colMeans(img, dims = 2)
    }
    list(rgb = val, html = rgb(val[1], val[2], val[3]))
}

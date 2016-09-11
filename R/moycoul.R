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

#' @importFrom grDevices rgb
moycoul_enhanced <- function(img) {

  # on coupe img en 4
  # browser()

  coupe_x <- round(dim(img)[1]/2)
  coupe_y <- round(dim(img)[2]/2)

  yop <- lapply(list(A=img[1:coupe_x,1:coupe_y,],B=img[1:coupe_x,coupe_y:dim(img)[2],],C=img[coupe_x:dim(img)[1],1:coupe_y,], D=img[coupe_x:dim(img)[1],coupe_y:dim(img)[2],]),FUN=colMeans, dims = 2)

  html<-sapply(yop,function(val){rgb(val[1], val[2], val[3])})

  # if (is.null(dim(img))) {
  #   val <- img
  #
  # } else {
  #   val <- colMeans(img, dims = 2)
  #
  # }
  list(rgb = yop, html = html)
}

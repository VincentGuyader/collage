# -*- coding: utf-8 -*-
#' @encoding UTF-8
#' @title resize
#' @description redimensionne une image au format array
#' @param arr array à redimensionner
#' @param x nouvelle dimension en x
#' @param y nouvelle dimension en y
#' @importFrom raster raster
#' @importFrom raster extent
#' @importFrom raster as.matrix
#' @importFrom raster resample

resize <- function(arr, x, y) {
    ss <- raster(ncol = x, nrow = y)
    arr2 <- array(dim = c(x, y, 3))
    arr2[, , 1] <- bim(arr[, , 1], ss)
    arr2[, , 2] <- bim(arr[, , 2], ss)
    arr2[, , 3] <- bim(arr[, , 3], ss)
    arr2
}
# dim(ert<-alply(arr,.margins=3,.fun=bim))


bim <- function(lay, ss) {
    tod <- raster(lay)
    extent(tod) <- extent(ss)
    rr <- as.matrix(resample(tod, ss))
    return(rr)
}



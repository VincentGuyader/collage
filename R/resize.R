# -*- coding: utf-8 -*-
#' @encoding UTF-8
#' @title resize
#' @description redimensionne une image au format array
#' @param arr array à redimensionner
#' @param x nouvelle dimension en x
#' @param y nouvelle dimension en y
#'
#'

resize <- function(arr, x, y) {
    ss <- raster::raster(ncol = x, nrow = y)
    arr2 <- array(dim = c(x, y, 3))
    arr2[, , 1] <- bim(arr[, , 1], ss)
    arr2[, , 2] <- bim(arr[, , 2], ss)
    arr2[, , 3] <- bim(arr[, , 3], ss)
    arr2
}
# dim(ert<-alply(arr,.margins=3,.fun=bim))


bim <- function(lay, ss) {
    tod <- raster::raster(lay)
    raster::extent(tod) <- raster::extent(ss)
    rr <- raster::as.matrix(raster::resample(tod, ss))
    return(rr)
}



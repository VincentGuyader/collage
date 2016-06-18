#' @title resize
#' @description redim d'une image en array
#' @param arr array
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

 

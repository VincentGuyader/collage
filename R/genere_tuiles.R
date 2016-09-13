# -*- coding: utf-8 -*-
#' @encoding UTF-8
#' @title genere_tuiles
#' @description genère des images mono couleurs
#' @param comb a matrix of data frame of RGB combinations
#' @param dir path where to write the tiles
#' @param width width of the generated tiles
#' @param height height of the generated tiles
#' @importFrom grDevices jpeg
#'
#' @examples
#' \dontrun{
#'   comb<-expand.grid(a1=seq(0,1,0.15),a2=seq(0,1,0.15),a3=seq(0,1,0.15))
#'   dir <- tempfile()
#'   generate_mono_tiles(lescomb,dir)
#' }
#' @importFrom grDevices jpeg
#' @export
generate_mono_tiles <- function(comb, dir, width = 100, height = 100) {
    try(dir.create(dir))

    colors <- rgb( combinaisons[,1], combinaisons[,2], combinaisons[,3] )
    sapply( colors, function(color){
      f <- file.path( dir, sprintf( "%s.jpg", color ) )
      jpeg(f, width = width, height = height )
      plot(1, xlab = "", ylab = "", type = "n", bty = "n", axes = FALSE)
      dev.off()
    })
}

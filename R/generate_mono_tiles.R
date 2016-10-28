#' generate monochromatic tiles
#'
#' @param comb a matrix of data frame of RGB combinations
#' @param dir path where to write the tiles
#' @param size width and height of the generated tiles
#'
#' @examples
#' \dontrun{
#'   comb <- expand.grid(a1=seq(0,1,0.15),a2=seq(0,1,0.15),a3=seq(0,1,0.15))
#'   dir  <- tempfile()
#'   generate_mono_tiles(comb, dir)
#' }
#' @importFrom grDevices jpeg rgb
#' @export
generate_mono_tiles <- function(comb, dir, size = 25) {
  try(dir.create(dir))

  colors <- rgb( comb[,1], comb[,2], comb[,3] )
  sapply( colors, function(color){
    f <- file.path( dir, sprintf( "%s.jpg", substring(color,2) ) )
    jpeg(f, width = size, height = size )
    par( mar = c(0,0,0,0) , bg = color)
    plot(1, xlab = "", ylab = "", type = "n", bty = "n", axes = FALSE)
    dev.off()
  })
}

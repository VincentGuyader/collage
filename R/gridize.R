#' adds a grid to show the parts of the image to be replaced by tiles
#'
#' @examples
#'   img <- sample_image()
#'   g <- gridize( file = img, width = 10, height = 10, col = "white", size = 2)
#'   plot( as.raster(g) )
#' @importFrom assertthat assert_that
#' @importFrom grDevices col2rgb
#' @export
gridize <- function( img = readJPEG(file), width = NA, height = NA, size = 1, col = "white", average = FALSE, file ){
  if( missing(file) ) assert_that(is_image(img))
  rgb <- as.vector( col2rgb(col) ) / 256

  dims <- auto_dim(dim(img), width, height)
  width <- dims[1]
  height <- dims[2]

  gridize_cpp( img, width, height, size, rgb, average )
}

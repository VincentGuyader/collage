as_bitmap <- function(img){
  if( inherits(img, "magick-image")){
    img <- img[[1]]
  }
  assert_that( inherits(img, "bitmap") )
  img
}

#' pixelize
#'
#' @param img image to process
#' @param base tile base, e.g. \code{base_samples}
#' @param size number of pixels, each square of \code{size} times \code{size} is replaced by the
#'             closest tile from \code{base}
#'
#' @examples
#' \dontrun{
#'   img <- sample_image()
#'   pixelize( file = img, size = 10)
#' }
#' @importFrom assertthat assert_that
#' @importFrom magick image_read
#' @export
pixelize <- function(img, base = base_samples, size = 10 ) {
  img <- as_bitmap(img)

  best_tiles  <- find_best_tiles(img, size, base$base )
  distances <- attr(best_tiles, "distances")

  tiles     <- base$read
  tile_size <- base$size
  width     <- attr(best_tiles, "width")
  height    <- attr(best_tiles, "height")

  out <- collage( tiles, width, height, best_tiles, tile_size )
  attr( out, "quality") <- summary(distances)

  used_tiles <- length( unique( best_tiles ) )
  attr( out, "tiles_use" ) <- list( percent = used_tiles/nrow(base$base), n = used_tiles )

  image_read(out)
}

#' kittenize
#'
#' version of \code{\link{pixelize}} using kittens
#'
#' @param \dots see \code{\link{pixelize}}
#' @examples
#' \dontrun{
#'   kittenize(file = sample_image())
#' }
#' @export
kittenize <- function(...) pixelize(..., base = kittens)

#' visual representation of the quality of the base
#'
#' splits the image in pixels of \code{size} x \code{size}
#'
#' for each of these pixels find the best tile in the tile base and retrieve its distance
#' to the average color of the pixel (distance is between 0 and 1),
#'
#' The rendered image is a gray scale of these distances.
#'
#' @param img image to pixelize
#' @param base tile base to use
#' @param size size (height and width) of each pixel
#' @param min_distance anything below this value is represented in white
#' @param max_distance anything above this value is represented in black
#'
#' @return an \code{\link[magick]{imagemagick}} object
#'
#' @importFrom magick image_read
#' @export
show_base_quality <- function( img, base = base_samples, size, min_distance = 0, max_distance ){
  img <- as_bitmap(img)
  best_tiles  <- find_best_tiles(img, size, base$base )
  distances <- attr(best_tiles, "distances")
  width <- attr(best_tiles, "width")
  height <- attr(best_tiles, "height")
  if( missing(max_distance) ){
    max_distance <- max(distances)
  }
  image_read(base_mask( distances, width, height, size, min_distance, max(distances)))
}

#' Adds a grid to show the parts of the image to be replaced by tiles
#'
#' @param img image
#' @param size pixel size
#' @param grid_col color to use for the grid
#'
#' @examples
#' \dontrun{
#'   img <- image_read( sample_image() )
#'   g <- gridize( img, size = 10, grid_col = "white" )
#'   plot( as.raster(g) )
#' }
#' @importFrom assertthat assert_that
#' @importFrom grDevices col2rgb
#' @export
show_grid <- function( img, size = 10, grid_col = "white" ){
  img <- as_bitmap(img)
  rgb <- as.raw( col2rgb(grid_col) )

  image_read( add_grid_cpp( img, size, rgb) )
}


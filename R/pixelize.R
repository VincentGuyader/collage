as_bitmap <- function(img){
  if( inherits(img, "magick-image")){
    img <- img[[1]]
  }
  img
}

#' Image collage
#'
#' @param img image to process
#' @param tiles tiles to use, e.g. \code{samples}
#' @param size number of pixels, each square of \code{size} times \code{size} is replaced by the closest tile
#'
#' @examples
#' \dontrun{
#'   img <- sample_image()
#'   collage( file = img, size = 10)
#' }
#' @importFrom magick image_read
#' @export
collage <- function(img, tiles = samples, size = 10 ) {
  img <- as_bitmap(img)

  best_tiles  <- find_best_tiles(img, size, tiles)
  distances <- attr(best_tiles, "distances")
  tile_size <- ncol(tiles$tile[[1]])

  width     <- attr(best_tiles, "width")
  height    <- attr(best_tiles, "height")

  out <- collage_impl( tiles$tile, width, height, best_tiles, tile_size )
  attr( out, "quality") <- summary(distances)

  used_tiles <- length( unique( best_tiles ) )
  attr( out, "tiles_use" ) <- list( percent = used_tiles/nrow(tiles), n = used_tiles )

  image_read(out)
}

#' visual representation of the quality of the tiles
#'
#' splits the image in pixels of \code{size} x \code{size}
#'
#' for each of these pixels find the best tile in the tile base and retrieve its distance
#' to the average color of the pixel (distance is between 0 and 1),
#'
#' The rendered image is a gray scale of these distances.
#'
#' @param img image to pixelize
#' @param tiles tile base to use
#' @param size size (height and width) of each pixel
#' @param min_distance anything below this value is represented in white
#' @param max_distance anything above this value is represented in black
#'
#' @return an \code{\link[magick]{imagemagick}} object
#'
#' @importFrom magick image_read
#' @export
collage_quality <- function( img, tiles = samples, size, min_distance = 0, max_distance ){
  img <- as_bitmap(img)
  best_tiles  <- find_best_tiles(img, size, tiles )
  distances <- attr(best_tiles, "distances")
  width <- attr(best_tiles, "width")
  height <- attr(best_tiles, "height")
  if( missing(max_distance) ){
    max_distance <- max(distances)
  }
  distances[is.nan(distances)] <- 1
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
#'
#'   # a grid of 10x10 tiles
#'   collage_grid( img, size = 10, grid_col = "white" )
#'
#'   # a grid with 10 lines
#'   collage_grid( img, size = lines_cut(img, 10) )
#'
#'   # a grid with 10 columns
#'   collage_grid( img, size = columns_cut(img, 10) )
#' }
#' @importFrom grDevices col2rgb
#' @export
collage_grid <- function( img, size = 10, grid_col = "white" ){
  img <- as_bitmap(img)
  rgb <- as.raw( col2rgb(grid_col) )

  image_read( add_grid_cpp( img, size, rgb) )
}

image_cut <- function(img, n = 10, direction = c("lines", "columns")){
  img <- as_bitmap(img)
  height <- dim(img)[3]
  width  <- dim(img)[2]
  direction <- match.arg( direction )
  x <- if(direction=="lines") height else width
  out    <- floor( x / n )

  attr(out, "lost") <- c( bottom = height %% out, right = width %% out)
  out
}

#' get the right size to split the image into a given number of lines
#'
#' @param img an image
#' @param n the number of lines
#'
#' @return a number of lines, in addition the \code{lost} attribute
#'  holds the number of lost pixels at the bottom and the right
#' @export
lines_cut <- function(img, n = 10){
  image_cut( img, n, direction = "lines")
}

#' get the right size to split the image into a given number of columns
#'
#' @param img an image
#' @param n the number of columns
#'
#' @return a number of columns, in addition the \code{lost} attribute
#'  holds the number of lost pixels at the bottom and the right
#' @export
columns_cut <- function(img, n = 10){
  image_cut( img, n, direction = "columns")
}

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
#' @export
pixelize <- function(img, base = base_samples, size = 10 ) {
  img <- as_bitmap(img)
  best_tiles  <- find_best_tiles(img, size, base$base )

  distances <- attr(best_tiles, "distances")
  get_quality <- function(fun){
    fun( 1 - distances / sqrt(3) )
  }

  tiles <- base$read
  tile_dim <- nrow(tiles[[1]])
  out <- collage( base$read, width, height, best_tiles, tile_dim )
  attr( out, "quality") <- get_quality(summary)

  used_tiles <- length( unique( best_tiles ) )
  attr( out, "tiles_use" ) <- list( percent = used_tiles/nrow(base$base), n = used_tiles )
  out
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

#' @export
show_base_quality <- function( img = readJPEG(file), base = base_samples, max_distance = .1, width = NA, height = NA, file){
  if( missing(file) ){
    assert_that(is_image(img))
  }
  dims <- auto_dim(dim(img), width, height)
  width <- dims[1]
  height <- dims[2]

  best_tiles  <- find_best_tiles(img, width, height, base$base )

  distances <- pmin( attr(best_tiles, "distances") / sqrt(3), max_distance ) / max_distance

  data <- array( rep(distances, 3), dim = c(height, width, 3) )
  data
}

#' adds a grid to show the parts of the image to be replaced by tiles
#'
#' @examples
#' \dontrun{
#'   img <- sample_image()
#'   g <- gridize( file = img, width = 10, height = 10, col = "white", size = 2)
#'   plot( as.raster(g) )
#' }
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


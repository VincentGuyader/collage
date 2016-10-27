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

#' @importFrom magick image_read
#' @export
show_base_quality <- function( img, base = base_samples, size, max_distance = .1){
  img <- as_bitmap(img)
  best_tiles  <- find_best_tiles(img, size, base$base )
  distances <- attr(best_tiles, "distances")
  width <- attr(best_tiles, "width")
  height <- attr(best_tiles, "height")

  out <- base_mask( distances, width, height, size, max_distance )
  image_read(out)
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


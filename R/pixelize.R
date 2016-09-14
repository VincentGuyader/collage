#' @export
auto_dim <- function( original_dim, width = NA, height = NA ){
  nr <- original_dim[1]
  nc <- original_dim[2]
  ratio <- nc / nr

  if( is.na(width) && is.na(height) ){
    height <- 100
    width  <- round(height * ratio)
  } else if(is.na(width) ){
    width <- round( height * ratio )
  } else if(is.na(height)){
    height <- round( width / ratio)
  }
  c( width, height )

}

#' pixelize
#'
#' @examples
#' img <- sample_image()
#' pixelize( file = img, width = 10)
#' @importFrom jpeg readJPEG
pixelize <- function(img = readJPEG(file), base = base_samples, width=NA, height=NA, file ) {
  if( missing(file) ){
    assert_that(is_image(img))
  }
  dims <- auto_dim(dim(img), width, height)
  width <- dims[1]
  height <- dims[2]

  best_tiles  <- find_best_tiles(img, width, height, base$base )

  distances <- attr(best_tiles, "distances")
  get_quality <- function(fun){
    fun( 1 - distances / sqrt(3) )
  }

  tiles <- base$read
  tile_dim <- nrow(tiles[[1]])
  out <- collage( base$read, width, height, best_tiles, tile_dim )
  attr( out, "quality") <- get_quality(summary)
  attr( out, "tiles_use" ) <- length( unique( best_tiles ) ) / nrow(base$base)
  out
}

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


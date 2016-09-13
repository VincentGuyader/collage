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
#' pixelize( img, width = 10)
#' @importFrom jpeg readJPEG
pixelize <- function(file, base = base_samples, width=NA, height=NA ) {
  img  <- readJPEG(file)
  dims <- auto_dim(dim(img), width, height)
  width <- dims[1]
  height <- dims[2]

  best_tiles  <- find_best_tiles(img, width, height, base$base )
  tiles <- base$read
  tile_dim <- nrow(tiles[[1]])
  out <- collage( base$read, width, height, best_tiles, tile_dim )
  out
}


# assumptions: tiles are square of all the same sizes. this can be the job of genere_base

auto_dim <- function( img, width = NA, height = NA ){
  nr <- nrow(img)
  nc <- ncol(img)
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
#' base <- system.file( "base", package = "tipixel")
#' img <- sample(list.files(base,full.names = TRUE),1)
#' les_tuiles <- genere_base(base,redim=c(25,25), progress = "text" )
#' pixelize( img, les_tuiles, width = 10)
#' @importFrom jpeg readJPEG
pixelize <- function(file, base, width=NA, height=NA ) {
  img  <- readJPEG(file)
  dims <- auto_dim(img, width, height)
  width <- dims[1]
  height <- dims[2]

  best_tiles  <- find_best_tile(img, width, height, base$base )
  tiles <- base$read
  tile_dim <- nrow(tiles[[1]])
  out <- collage( base$read, width, height, best_tiles, tile_dim )
  out
}

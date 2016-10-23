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

is_image <- function(img){
  length(dim(img)) == 3L && is.numeric(img) && all(img>=0 & img<=1)
}

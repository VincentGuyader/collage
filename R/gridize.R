
is_image <- function(img){
  length(dim(img)) == 3L && is.numeric(img) && all(img>=0 & img<=1)
}

#' @importFrom assertthat assert_that
#' @importFrom grDevices col2rgb
gridize <- function( img = readJPEG(file), width = NA, height = NA, size = 1, col = "white", file ){
  if( missing(file) ) assert_that(is_image(img))
  rgb <- as.vector( col2rgb(col) ) / 256

  dims <- auto_dim(dim(img), width, height)
  width <- dims[1]
  height <- dims[2]

  gridize_cpp( img, width, height, size, rgb )


}

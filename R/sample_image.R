#' Get the path of a sample image
#'
#' @param i index of the sample image, if missing an image is selected at random
#' @return the full path of a sample image
#'
#' @export
sample_image <- function(i){
  path <- system.file( "base", package = "tipixel")
  images <- list.files( path, pattern = "[.]jpe?g$", full.names = TRUE)
  if( missing(i) ) sample(images, 1) else images[i]
}

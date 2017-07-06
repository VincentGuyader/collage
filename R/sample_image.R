#' Get the path of a sample image
#'
#' @param i index of the sample image, if missing an image is selected at random
#' @return the full path of a sample image
#'
#' @export
sample_image <- function(i){
  path <- system.file( "base", package = "collage")
  images <- list.files( path, pattern = "[.]jpe?g$", full.names = TRUE)
  if( missing(i) ) {
    i <- sample(length(images), 1)
  }

  images[i]
}

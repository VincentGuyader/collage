#' Get the path of a sample image
#'
#' @param i index of the sample image, if missing an image is selected at random
#' @return the full path of a sample image
#'
#' @export
sample_image <- function(i){
  images <- jpegs(system.file( "base", package = "tipixel"))
  if( missing(i) ) sample(images, 1) else images[i]
}

#' get the list of jpegs from a directory
#'
#' @param path the directory
#' @param \dots passed to \code{\link{list.files}}, mostly used for the \code{recursive} argument
#' @export
jpegs <- function(path, ... ){
  list.files( path, pattern = "[.](jpg|jpeg)$", full.names = TRUE, ... )
}

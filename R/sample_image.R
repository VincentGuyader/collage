#' Get the path of a sample image
#'
sample_image <- function(){
  sample(jpegs(system.file( "base", package = "tipixel")), 1)
}

#' get the list of jpegs from a directory
#'
#' @param path the directory
#' @param \dots passed to \code{\link{list.files}}, mostly used for the \code{recursive} argument
jpegs <- function(path, ... ){
  list.files( path, pattern = "[.](jpg|jpeg)$", full.names = TRUE, ... )
}

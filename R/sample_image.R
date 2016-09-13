#' Get the path of a sample image
#'
sample_image <- function(){
  path <- system.file( "base", package = "tipixel")
  sample(list.files(base,full.names = TRUE),1)
}

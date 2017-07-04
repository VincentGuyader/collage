image_center_crop_geometry <- function(img){
  info <- image_info(img)
  width <- info$width
  height <- info$height

  geometry <- if( width > height){
    offset <- ( width - height ) / 2
    sprintf( "%dx%d+%d", height, height, offset)
  } else {
    offset <- (height - width )  / 2
    sprintf( "%dx%d+0+%d", width, width, offset)
  }
  geometry
}

#' Crops a square in the center of the image
#'
#' @param img an image, typically loaded with \code{\link[magick]{image_read}} or some
#' other function from \code{magick}
#' @return a square image
#' @importFrom magick image_info image_crop
#' @export
image_center_crop <- function(img){
  image_crop(img, geometry = image_center_crop_geometry(img) )
}

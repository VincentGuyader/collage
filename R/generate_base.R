#' makes tiles from jpegs in a directory
#'
#' importe le contenu du dossier de tuiles et génère un objet base
#' @param files image files
#' @param size size (width and height) of the generated tiles
#'
#' @examples
#' \dontrun{
#' images <- jpegs( system.file("base", package = "tipixel" ) )
#' generate_base(images, size = 25)
#' }
#' @importFrom tibble data_frame
#' @importFrom magick image_read image_scale
#' @export
generate_base <- function(files, size = 25){
  images <- image_read(files)
  scaled <- image_scale( images, "1x1!" )

  grab <- function(channel){
    sapply( scaled, function(.){
      .[[1]][channel]
    })
  }
  first <- function(.) .[[1]]

  base     <- data_frame( R = grab(1), G = grab(2), B = grab(3))
  geometry <- sprintf( "%dx%d!", size, size )
  tiles    <- image_scale(images, geometry) %>% lapply(first)

  structure( list( base=base, read=tiles, size = size), class ="unebase" )
}

#' @export
print.unebase <- function(x, ...) {
  cat( sprintf("image base with %d tiles (%dx%d)\n", nrow(x$base), x$size, x$size ) )
}

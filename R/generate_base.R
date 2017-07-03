# not as safe as the real thing but that's fine for now
# just rm this when/if this PR is merged into purrr
# https://github.com/tidyverse/purrr/pull/345
map_raw <- function(...) unlist(purrr::map(...))

#' Generates a tile base from a set of files
#'
#' importe le contenu du dossier de tuiles et génère un objet base
#' @param files image files
#' @param size size (width and height) of the generated tiles
#'
#' @examples
#' \dontrun{
#'   path   <- system.file("base", package = "tipixel" )
#'   images <- list.files( path, pattern= "jpg$", full.names = TRUE )
#'   generate_base(images, size = 25)
#' }
#' @importFrom tibble data_frame
#' @importFrom magick image_read image_scale
#' @importFrom purrr map
#' @export
generate_base <- function(files, size = 25){
  images <- image_read(files)
  scaled <- image_scale( images, "1x1!" )

  first <- function(.) .[[1]]
  grab <- function(channel) map_raw( as.list(scaled), ~ first(.)[channel] )

  base     <- data_frame( R = grab(1), G = grab(2), B = grab(3))
  geometry <- sprintf( "%dx%d!", size, size )
  tiles    <- map( as.list(image_scale(images, geometry)), first )

  structure( list( base=base, read=tiles, size = size), class ="unebase" )
}

#' @export
print.unebase <- function(x, ...) {
  cat( sprintf("image base with %d tiles (%dx%d)\n", nrow(x$base), x$size, x$size ) )
}

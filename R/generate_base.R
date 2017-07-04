# not as safe as the real thing but that's fine for now
# just rm this when/if this PR is merged into purrr
# https://github.com/tidyverse/purrr/pull/345
map_raw <- function(...) unlist(purrr::map(...))

extract2 <- `[[`

image_square <- function( images, size = 25){
  geometry <- sprintf( "%dx%d!", size, size )
  image_scale(images, geometry) %>%
    as.list() %>%
    map( extract2, 1L )
}

#' Generates a tile base from a set of files
#'
#' importe le contenu du dossier de tuiles et génère un objet base
#' @param files image files
#' @param size size (width and height) of the generated tiles
#'
#' @examples
#' \dontrun{
#'   path   <- system.file("base", package = "tipixel" )
#'   files <- list.files( path, pattern= "jpg$", full.names = TRUE )
#'   generate_base(files, size = 25)
#' }
#' @importFrom tibble tibble
#' @importFrom magick image_read image_scale
#' @importFrom purrr map map_df
#' @importFrom magrittr %>%
#' @export
generate_base <- function(files, size = 25L){
  images <- image_read(files)

  scaled <- image_square(images, 1L)
  tiles  <- image_square(images, size)
  grab   <- function(i) map_raw(scaled, extract2, i)
  tibble( R = grab(1), G = grab(2), B = grab(3), tile = tiles)
}

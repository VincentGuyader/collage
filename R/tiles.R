# not as safe as the real thing but that's fine for now
# just rm this when/if this PR is merged into purrr
# https://github.com/tidyverse/purrr/pull/345
map_raw <- function(...) unlist(purrr::map(...))

extract2 <- `[[`

image_square_bitmap <- function( images, size = 25){
  geometry <- sprintf( "%dx%d!", size, size )
  image_scale(images, geometry) %>%
    as.list() %>%
    map( extract2, 1L )
}

#' Generates a tile base from a set of files
#'
#' @param files image files
#' @param size size (width and height) of the generated tiles
#'
#' @return a tibble with the columns R, G, B (raw vectors) and tile
#' @examples
#' \dontrun{
#'   path  <- system.file("base", package = "tipixel" )
#'   files <- list.files( path, pattern= "jpg$", full.names = TRUE )
#'   tiles(files, size = 25)
#' }
#' @importFrom tibble tibble
#' @importFrom magick image_read image_scale
#' @importFrom purrr map map_df
#' @importFrom magrittr %>%
#' @export
tiles <- function(files, size = 25L){
  images <- image_read(files)

  scaled <- image_square_bitmap(images, 1L)
  tiles  <- image_square_bitmap(images, size)
  grab   <- function(i) map_raw(scaled, extract2, i)
  tibble( red = grab(1), green = grab(2), blue = grab(3), alpha = grab(4), tile = tiles)
}

columns <- function(m){
  set_names( map(seq_len(ncol(m)), ~m[,.]), colnames(m) )
}

mono_tile_bitmap <- function(r, g, b, a, size){
  structure( array( rep( c(r,g,b,a), size*size ), dim = c(4,size, size) ), class = c( "bitmap", "rgba") )
}

#' monochromatic tiles
#'
#' @param colors a vector of colors that can be handled by \code{\link[grDevices]{col2rgb}}
#'
#' @return a tiles tibble.
#' @seealso \code{\link{tiles}}
#'
#' @importFrom grDevices col2rgb
#' @importFrom tibble as_tibble
#' @importFrom dplyr mutate_all
#' @importFrom purrr pmap
#' @export
tiles_mono <- function( colors, size = 25L ){
  m <- t( col2rgb(colors, alpha = TRUE) )
  out <- as_tibble( map(columns(m), as.raw) )
  out$tile = pmap( with(out,list(red,green,blue,alpha)), mono_tile_bitmap, size = size)
  out
}


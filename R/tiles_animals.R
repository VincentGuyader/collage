
#' @importFrom magrittr %>%
#' @importFrom xml2 read_html
#' @importFrom rvest html_node html_text
npages <- function( what = "bebe,chats" ){
  url <- sprintf( "http://www.photos-animaux.com/photos,%s.html", what )
  read_html(url) %>%
    html_node("li.page") %>%
    html_text() %>%
    gsub( "^.* ([[:digit:]]+)$", "\\1", .) %>%
    as.numeric
}

#' @importFrom xml2 read_html
#' @importFrom rvest html_nodes html_attr
scrap <- function(page = 1, what = "bebe,chats" ){
  url <- sprintf( "http://www.photos-animaux.com/photos,%s;%d.html", what, page )
  read_html(url) %>%
    html_nodes( "._image img" ) %>%
    html_attr("src")
}

#' Get urls of animal pictures
#'
#' @param what type of pictures
#' @param pages the pages to download
#'
#' @importFrom purrr map flatten_chr
#' @export
scrap_animals <- function(what = "bebe,chats", pages ){
  if(missing(pages)){
    pages <- seq_len(npages(what))
  }
  pages %>%
    map( scrap, what = what) %>%
    flatten_chr()
}

#' Tiles from animal pictures
#'
#' @param what type of pictures
#' @param pages the pages to download
#' @param size tile size
#'
#' @examples
#' \dontrun{
#'
#'   kittens <- tiles_animals( size = 50, what = "bebe,chats", pages = 1:20 )
#'   puppies <- tiles_animals( size = 50, what = "bebe,chiens", pages = 1:20 )
#' }
#' @importFrom purrr walk2
#' @importFrom utils download.file
#' @export
tiles_animals <- function(size = 25, what = "bebe,chats", pages){
  dir.create( tf <- tempfile() )
  on.exit( unlink(tf, recursive = TRUE))

  urls <- scrap_animals(what = what, pages = pages)
  dest <- file.path( tf, basename(urls) )

  walk2( urls, dest, download.file, quiet = TRUE  )
  tiles( dest, size = size )
}




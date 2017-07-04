
#' @importFrom magrittr %>%
#' @importFrom xml2 read_html
#' @importFrom rvest html_node html_text
#' @export
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

#' @importFrom purrr map flatten_chr
#' @export
scrap_animals <- function(what = "bebe,chats", pages, .progress = "text", ...){
  if(missing(pages)){
    pages <- seq_len(npages(what))
  }
  pages %>%
    map( scrap, what = what) %>%
    flatten_chr()
}

#' @importFrom purrr walk2
#' @export
tiles_animals <- function(size = 25, what = "bebe,chats", pages, .progress = "text", ...){
  dir.create( tf <- tempfile() )
  on.exit( unlink(tf, recursive = TRUE))

  urls <- scrap_animals(what = what, pages = pages, .progress = .progress, ...)
  dest <- file.path( tf, basename(urls) )

  walk2( urls, dest, download.file, quiet = TRUE  )
  tiles( dest, size = size )
}




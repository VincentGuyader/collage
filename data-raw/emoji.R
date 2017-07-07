library(rvest)
library(tidyverse)

links <- read_html("https://emojipedia.org/apple/") %>%
  html_nodes( ".emoji-grid a img")

dir.create( tf <- "data-raw/emojis" )

data <- tibble(
  alt = links %>% html_attr("alt"),
  img = links %>% html_attr("src"),
  datasrc = links %>% html_attr("data-src")
) %>%
  mutate(
    img = ifelse( img == "/static/img/lazy.svg", datasrc, img ),
    dest = paste0(tf, "/", row_number(), ".png")
  )

i <- 1
walk2( data$img, data$dest, ~{
  cat( i, ' / ', nrow(data), "\r" )
  download.file( .x, .y, quiet = TRUE  )
  i <<- i + 1
})

files <- list.files( tf )
o <- order( as.numeric( files, str_replace( files, ".png", "" )) )
files <- files[o]


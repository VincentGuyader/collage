library(rvest)
library(purrr)
library(tibble)
library(dplyr)
library(stringr)

attendees <- function(page) {
  extract <- function(class) html_node( persons, class ) %>% html_text() %>% str_trim()

  url <- paste0( 'https://user2017.sched.com/directory/attendees/', page )
  persons <- read_html(url) %>%
    html_nodes(".sched-person")
  tibble(
    position = extract(".sched-event-details-position"),
    company  = extract(".sched-event-details-company"),
    avatar = html_node(persons, ".sched-avatar") %>% html_attr("href") %>% str_replace("^[/]", ""),
    id = extract("h2:nth-child(2) a"),
    img = html_node(persons, "img") %>% html_attr("src")
  )
}

data <- map_df( 1:6, attendees )
data <- data %>% filter( !is.na(img) )

dir.create( tf <- tempfile() )
walk2(data$img, data$avatar, ~try( download.file(.x, dest = file.path(tf, sprintf("%s.jpg", .y) ) ), silent = TRUE ) )

pics <- tibble(
  pic = list.files(tf),
  avatar = str_replace( pic, "[.][^.]+$", "" )
)

data2 <- right_join( data, pics, by = "avatar" )

tiles_useR2017 <- tiles( file.path( tf, data2$pic ), size = 50 )
tiles_useR2017 <- bind_cols( tiles_useR2017, select( data2, id, position, company, avatar )



#' Image histograms
#'
#' Histograms are a tool used in photography to visualise the tonal
#' distribution of a picture.
#'
#' For each channel (red, green, blue), the histogram displays on
#' the tone (from 0 to 255) on the x axis, and the pixel count on the y axis.
#'
#' The three channels can be combined together to form the brightness
#' histogram.
#'
#' The `image_histogram_data` function makes a `tibble` with 4 columns :
#' - `tone` : sequence from 0 to 255.
#' - `red`, `green`, `blue` : pixel count for each channel.
#'
#' The `image_histogram_brightness` makes a `ggplot` object showing the
#' brightness histogram.
#'
#' The `image_histogram_rgb` makes a `ggplot` object showing the histograms
#' for each channel.
#'
#' @param im image, such as on read by [image::image_read]
#'
#' @examples
#' \dontrun{
#' tigrou <- image_read( "inst/tigrou/tigrou.jpg")
#' image_histogram_data(tigrou)
#' image_histogram_brightness(tigrou)
#' image_histogram_rgb(tigrou)
#' }
#'
#' @rdname image_histogram
#'
#' @importFrom tibble as_tibble
#' @importFrom dplyr mutate
#' @importFrom magrittr %>%
#'
#' @export
image_histogram_data <- function(im){
  bitmap <- im[[1]]
  as_tibble(magick_image_histogram(bitmap))
}

#' @param coefficients luma coefficients
#' @rdname image_histogram
#' @import ggplot2
#' @importFrom grDevices gray
#' @export
image_histogram_brightness <- function(im, coefficients = c(0.3, 0.6, 0.1)){
  h <- image_histogram_data(im) %>%
    mutate(
      brightness = coefficients[1]*red + coefficients[2]*green + coefficients[3]*blue,
      col = gray( tone / 255)
    )

  ggplot(h) +
    aes(xmin = tone - 0.5, xmax = tone +.5, ymin = 0, ymax = brightness) +
    geom_rect( fill = h$col ) +
    guides(colour = FALSE)
}

#' @rdname image_histogram
#' @importFrom dplyr select mutate case_when
#' @importFrom tidyr gather
#' @export
image_histogram_rgb <- function(im){
  h <- image_histogram_data(im) %>%
    select(tone, red, green, blue) %>%
    gather(col, value, -tone) %>%
    mutate(
      colour = case_when(
        col == "red"   ~ rgb( tone / 255, 0, 0),
        col == "green" ~ rgb( 0, tone / 255, 0),
        col == "blue"  ~ rgb( 0, 0, tone / 255)
      )
    )

  ggplot(h) +
    aes( xmin = tone - .5, xmax = tone + .5, ymin = 0, group = col ) +
    theme(
      strip.background = element_blank(), strip.text.x = element_blank(),
      axis.text.x = element_blank(), axis.ticks.x = element_blank()
    ) +
    geom_rect( aes(ymax = value), fill = h$colour) +
    facet_wrap(~col, nrow = 3) +
    guides(colour = FALSE)+
    ggtitle("")
}

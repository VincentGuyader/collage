
#' Calculates an image histogram
#'
#' @param im image
#'
#' @return a data frame of 256 rows with columns `intensity`, `red`, `green`, `blue` and `luminosity`
#'
#' The `intensity` columns goes from 0 to 255. The `red`, `green` and `blue` column count the number of pixels
#' in the image with corresponding intensity.
#'
#' The `luminosity` column is calculated using the luma coefficients (0.3, 0.6 and 0.1) on the
#' color channels.
#'
#' @importFrom tibble as_tibble
#' @importFrom dplyr mutate
#' @importFrom magrittr %>%
#'
#' @export
image_histogram_data <- function(im){
  magick_image_histogram( im[[1]] ) %>%
    as_tibble() %>%
    mutate( luminosity = 0.3*red + 0.6*green + 0.1*blue)
}

#' luminosity histogram
#'
#' @rdname histogram
#' @param im an image
#'
#' @return a ggplot2 object
#'
#' @examples
#' \dontrun{
#' tigrou <- image_read( "inst/tigrou/tigrou.jpg")
#' histogram_luminosity(tigrou)
#' histogram_rgb(tigrou)
#' }
#' @import ggplot2
#' @export
histogram_luminosity <- function(im){
  h <- image_histogram_data(im) %>%
    mutate( col = gray( intensity / 255) )

  ggplot(h) +
    aes(xmin = intensity - 0.5, xmax = intensity +.5, ymin = 0, ymax = luminosity) +
    theme_void() +
    geom_rect( fill = h$col ) +
    guides(colour = FALSE)
}

#' @importFrom dplyr select mutate case_when
#' @importFrom tidyr gather
#' @rdname histogram
#' @export
histogram_rgb <- function(im){
  h <- image_histogram_data(im) %>%
    select(intensity:blue) %>%
    gather(col, value, -intensity) %>%
    mutate(
      colour = case_when(
        col == "red"   ~ rgb( intensity / 255, 0, 0),
        col == "green" ~ rgb( 0, intensity / 255, 0),
        col == "blue"  ~ rgb( 0, 0, intensity / 255)
      )
    )

  ggplot(h) +
    aes( xmin = intensity - .5, xmax = intensity + .5, ymin = 0, group = col ) +
    theme(
      strip.background = element_blank(), strip.text.x = element_blank(),
      axis.text.x = element_blank(), axis.ticks.x = element_blank()
    ) +
    geom_rect( aes(ymax = value), fill = h$colour) +
    facet_wrap(~col, nrow = 3) +
    guides(colour = FALSE)+
    ggtitle("")
}

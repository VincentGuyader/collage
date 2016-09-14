
#' @import shiny
#' @import shinyFiles
#' @export
shinypixel <- function() {
  shinyApp( ui = pixel_ui(), server = pixel_server() )
}

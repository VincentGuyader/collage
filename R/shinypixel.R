#' Run shiny app
#'
#' @export
#' @examples
#' \dontrun{
#' collage::shinypixel()
#' }
shinypixel <- function() {
  appDir <- system.file("shinypixel", package = "collage")
  if (appDir == "") {
    stop("Could not find . Try re-installing `collage`.", call. = FALSE)
  }
  shiny::runApp(appDir, display.mode = "normal")
}

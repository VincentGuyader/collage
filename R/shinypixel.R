#' Run shiny app
#'
#' @export
#' @examples
#' \dontrun{
#' tipixel::shinypixel()
#' }
shinypixel <- function() {
  appDir <- system.file("shinypixel", package = "tipixel")
  if (appDir == "") {
    stop("Could not find . Try re-installing `tipixel`.", call. = FALSE)
  }
  shiny::runApp(appDir, display.mode = "normal")
}

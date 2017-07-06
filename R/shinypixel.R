#' Run shiny app
#'
#' @param display.mode display mode
#' @param \dots see \code{\link[shiny]{runApp}}
#' @export
#' @examples
#' \dontrun{
#' collage::shinycollage()
#' }
shinycollage <- function(display.mode = "normal", ...) {
  appDir <- system.file("shiny", package = "collage")
  if (appDir == "") {
    stop("Could not find. Try re-installing `collage`.", call. = FALSE)
  }
  shiny::runApp(appDir, display.mode = display.mode, ... )
}

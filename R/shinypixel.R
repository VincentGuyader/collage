#' @export
shinypixel <- function() {
  appDir <- system.file("shinypixel", "shinypixel", package = "tipixel")
  if (appDir == "") {
    stop("Could not find example directory. Try re-installing `tipixel`.", call. = FALSE)
  }

  shiny::runApp(appDir, display.mode = "normal")
}

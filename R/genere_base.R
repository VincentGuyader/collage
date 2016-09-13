#' makes tiles from jpegs in a directory
#'
#' importe le contenu du dossier de tuiles et génère un objet base
#' @param path directory where to find the images
#' @param size size (width and height) of the generated tiles
#' @param \dots used by \code{\link{jpegs}}
#'
#' @examples
#' \dontrun{
#' path <- system.file("base", package = "tipixel" )
#' generate_base(path, size = 25)
#' }
#' @importFrom tibble data_frame
#' @importFrom jpeg readJPEG
#' @export
generate_base <- function(path, size = 25, ...){
  files  <- jpegs( path, ... )
  images <- sapply( files, readJPEG)
  data   <- lapply( images, make_tile, size=size)

  mean   <- t(sapply( data, "[[", "mean" ))
  base   <- data_frame( nom = rownames(mean), R = mean[,1], G = mean[,2], B = mean[,3] )
  row.names(base) <- NULL

  read   <- lapply( data, "[[", "img")

  structure( list( base=base, read=read, redim=c(size, size)), class ="unebase" )
}

#' @export
print.unebase <- function(x, ...) {
  cat("base de ", nrow(x$base), " tuiles \n")
  cat("exemple de chemin :",x$base[1,]$nom, "\n")
    if (!is.null(dim(x$read[[1]]))) {
        cat("base avec images préchargées \n ")
      if (!is.null(x$redim)){
        if (!is.na(x$redim[[1]])) {
            cat("taille :", x$redim)
        }
    }}
}

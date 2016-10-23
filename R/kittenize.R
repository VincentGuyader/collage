#' Bases of sample images
#'
#' @rdname bases
#' @examples
#'   kittens
"kittens"

#' @rdname bases
#' @examples
#'   base_samples
"base_samples"


#' kittenize
#'
#' version of \code{\link{pixelize}} using kittens
#'
#' @param \dots see \code{\link{pixelize}}
#' @examples
#' \dontrun{
#'   kittenize(file = sample_image())
#' }
#' @export
kittenize <- function(...) pixelize(..., base = kittens)

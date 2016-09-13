#' A base of kittens
#'
#' @examples
#'   kittens
"kittens"

# -*- coding: utf-8 -*-
#' @encoding UTF-8
#' @title kittenize
#' @description Pour ceux qui aiments les chatons
#' @param \dots see \code{\link{pixelize}}
#' @examples
#' \dontrun{
#' library(tipixel)
#'
#' kittenize(sample_image())
#' }

#' @export
kittenize <- function(...) pixelize(..., base = kittens)

# -*- coding: utf-8 -*-
#' @encoding UTF-8
#' @title decoupsynthpath
#' @description découpe et synthétise une image depuis son chemin
#' @param path chemin de l'image
#' @param redim dimension finale de l'image
#' @param verbose booleen rend la fonction bavarde
#' @param preload booleen si VRAI les images sont préchargées (prend de la RAM mais accelère le traitement)
#' @importFrom jpeg readJPEG
#' @export
decoupsynthpath <- function(path, redim = NULL, verbose = FALSE, preload = TRUE) {
    lim <- NULL
    if (verbose) {
        message(path)
    }
    try(lim <- aperm(readJPEG(path), c(2, 1, 3)))
    # microbenchmark(aperm(lim,c(2,1,3)),t_array(lim))

    if (length(lim) == 0) {
        out <- list(tab = data.frame(nom = NA, lig = NA, col = NA, R = NA, G = NA, B = NA, html = NA), read = NA)
        class(out) <- "tuile"
        return(out)
    }
    # decoupsynth_one(lim,redim=redim)
    mc <- moycoul(lim)
    out <- setNames(cbind(1, 1, 1, data.frame(matrix(mc$rgb, nrow = 1)), mc$html), c("nom", "lig", "col", "R", "G",
        "B", "html"))

    if (preload) {
        if (length(redim) != 0) {
            out <- list(tab = out, read = resize(lim, redim[1], redim[2]))
            class(out) <- "tuile"
            return(out)
        }
        out <- list(tab = out, read = lim)
        class(out) <- "tuile"
        return(out)
    } else {

        out <- list(tab = out, read = NA)
        class(out) <- "tuile"
        return(out)
    }
}

print.tuile <- function(x, ...) {

    cat(" une tuile de ", dim(x$read), " \n")
    print(x$tab)
    cat("\n\n")
}

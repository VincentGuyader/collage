# -*- coding: utf-8 -*-
#' @encoding UTF-8
#' @title decoupsynthpath
#' @description découpe et synthétise une image depuis son chemin
#' @param path chemin de l'image
#' @param redim dimension finale de l'image
#' @param verbose booleen rend la fonction bavarde
#' @param preload booleen si VRAI les images sont préchargées (prend de la RAM mais accelère le traitement)
#'
decoupsynthpath <- function(path, redim = NULL, verbose = FALSE, preload = TRUE) {
    lim <- NULL
    if (verbose) {
        message(path)
    }
    try(lim <- aperm(jpeg::readJPEG(path), c(2, 1, 3)))
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

# microbenchmark(decoupsynth_one(lim,redim=redim), decoupsynth(lim,1,1,redim),times=30 )


#' @title decoupsynth
#' @description decoupe et synthétise une image
#' @param img array de l 'image
#' @param lig nombre de ligne
#' @param col nombre de colonne
#' @param redim dimension finale de l'image
#' @export
#'

decoupsynth <- function(img, lig = 10, col = 10, redim = NULL,enhanced=FALSE) {

    a <- lapply(1:(lig), FUN = prout, base = round(seq.int(1, dim(img)[1], length.out = lig + 1)))
    b <- lapply(1:(col), FUN = prout, base = round(seq.int(1, dim(img)[2], length.out = col + 1)))
    tt <- expand.grid(x = a, y = b)
    ok <- apply(tt, MARGIN = 1, FUN = extr, img = img,enhanced=FALSE)

    # ce qui est au dessus ne semble pas bloquant, mais peut etre moycoul_enhancedencore optimisable ?
    # sapply(ok,FUN=function(x)x$html)

    # ICI CA MERDE A LA SORTIE DE OK EN MODE ENHANCED

    # do.call(cbind,ok[[1]]$rgb)

    out <- cbind(1:dim(tt)[1], tt, t(sapply(ok, FUN = function(x) x$rgb)), html = sapply(ok, FUN = function(x) x$html))
    names(out) <- c("nom", "lig", "col", "R", "G", "B", "html")

    if (length(redim) != 0) {

        return(list(tab = out, read = resize(img, redim[1], redim[2])))
    }
    out <- list(tab = out, read = img)
    class(out) <- "tuile"
    return(out)
}




extr <- function(vec, img,enhanced) {
  if (!enhanced){
   return(moycoul(
      img[seq(vec$x[1], vec$x[2]), seq(vec$y[1], vec$y[2]), ]
   ))}else{
     # save(img,file="aef.RData")
     # print(img)
     out <- moycoul_enhanced(

       img[seq(vec$x[1], vec$x[2]), seq(vec$y[1], vec$y[2]), ]
     )
     return(out)

      }

}

prout <- function(t, base) {
    return(base[t:(t + 1)])
}


print.tuile <- function(x, ...) {

    cat(" une tuile de ", dim(x$read), " \n")
    print(x$tab)
    cat("\n\n")
}

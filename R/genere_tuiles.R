# -*- coding: utf-8 -*-
#' @encoding UTF-8
#' @title genere_tuiles
#' @description genère des images mono couleurs
#' @param combinaisons data.frame avec 1 ligne = une combinaison R V B
#' @param dossier chemin du dossier de création des tuiles
#' @param dim, vecteur de taille 2, dimension en pixel des tuiles
#' @examples
#' ## Not run
#' lescomb<-expand.grid(a1=seq(0,1,0.15),a2=seq(0,1,0.15),a3=seq(0,1,0.15))
#' genere_tuiles(lescomb,dossier='base')
#' ## End(Not run)
#' @export


genere_tuiles <- function(combinaisons, dossier, dim = c(100, 100)) {

    try(dir.create(dossier))
    invisible(apply(combinaisons, MARGIN = 1, FUN = gendess, dossier = dossier, dim = dim))
}

gendess <- function(vec, dossier = "base", dim = c(100, 100)) {
    agen <- array(dim = c(1, 1, 3))
    agen[, , 1] <- vec[1]
    agen[, , 2] <- vec[2]
    agen[, , 3] <- vec[3]
    grDevices::jpeg(filename = paste0(dossier, "/base-", vec[1], "-", vec[2], "-", vec[3], ".jpg"), dim[1], dim[2])
    par(bg = moycoul(agen)$html)
    try(silent = T, plot(1, xlab = "", ylab = "", type = "n", bty = "n", axes = FALSE))
    dev.off()
}

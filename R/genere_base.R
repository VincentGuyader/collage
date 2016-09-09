# -*- coding: utf-8 -*-
#' @encoding UTF-8
#' @title genere_base
#' @description importe le contenu du dossier de tuiles et génère un objet base
#' @param chemin le chemin du dossier de tuiles
#' @param redim permet de redimensionner les tuiles
#' @param verbose rend la fonction bavarde
#' @param preload pre charge les images et rend la base indépendante des fichiers.. mais prend de la place en ram
#' @param recursive si VRAI va parcourir les sous dossiers
#' @param progress affiche la progression dans la console
#' @param nombre nombre de tuiles à inclure (aléatoire)
#' @examples
#' \dontrun{
#' base <- file.path(find.package('tipixel'),'base')
#' les_tuiles <- genere_base(base,redim=c(25,25))
#' genere_base(base)
#' genere_base(base,redim=c(25,25))
#' genere_base(base,redim=c(25,25),preload = FALSE)
#' }
#' @export


genere_base <- function(chemin = "base", redim = c(25,25), verbose = FALSE, preload = TRUE,recursive = TRUE,progress="text",nombre=NULL) {
    nom <- list.files(chemin, full.names = TRUE,pattern = "*.(jpg|jpeg)$",recursive = TRUE)

    if (!missing(nombre)){
    if (nombre<length(nom)){

      nom <-     nom[sample(seq_along(nom),nombre)]
    }
    }

    tout <- plyr::llply(nom, .fun = decoupsynthpath, redim = redim, verbose = verbose, .progress = progress, preload = preload)
    # options(warn = -1)
    suppressWarnings(
     LABASE <- cbind(nom, dplyr::bind_rows(lapply(tout, FUN = function(x) {
        x$tab
    }))[, -1]))
     # options(warn = 0)
    LABASE$nom <- as.character(LABASE$nom)
    lesREAD <- NA
    if (preload) {
        lesREAD <- lapply(tout, FUN = function(x) {
            x$read
        })
        names(lesREAD) <- LABASE$nom
        lesREAD <- lesREAD[!is.na(lesREAD)]
    }

    # on supprime de LABASE les truc vides
    suppressWarnings(
    LABASE$base <- na.omit(LABASE$base)
    )
    out <- list(base = LABASE, read = lesREAD, redim = redim)
    class(out) <- "unebase"
    out

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

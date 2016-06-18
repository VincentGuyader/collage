# -*- coding: utf-8 -*-
#' @title genre_base
#' @description li le contenu du dossier de tuiles et genere un objet base
#' @param chemin le chemin du dosier de tuiles
#' @param redim permet de redimensionner les tuiles
#' @param verbose rend la fonction bavarde
#' @param preload pre charge les images et rend la base indépendante des fichierrs.. mais prend de la place en ram
#' @examples les_tuiles <- genre_base('base',redim=c(25,25))
#' genre_base('base3')
#' genre_base('base3',redim=c(25,25))
#' genre_base('base3',redim=c(25,25),preload = FALSE)
#' @export


genre_base <- function(chemin = "base", redim = NULL, verbose = FALSE, preload = TRUE) {
    nom <- list.files(chemin, full.names = TRUE)
    tout <- plyr::llply(nom, .fun = decoupsynthpath, redim = redim, verbose = verbose, .progress = "text", preload = preload)
    LABASE <- cbind(nom, dplyr::bind_rows(lapply(tout, FUN = function(x) {
        x$tab
    }))[, -1])
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
    
    LABASE$base <- na.omit(LABASE$base)
    out <- list(base = LABASE, read = lesREAD, redim = redim)
    class(out) <- "unebase"
    out
    
}

#' @export
print.unebase <- function(x, ...) {
    
    cat("base de ", nrow(x$base), " tuiles \n")
    if (!is.null(dim(x$read[[1]]))) {
        cat("base avec images préchargées \n ")
        if (!is.na(x$redim[[1]])) {
            cat("taille :", x$redim)
        }
    }
    
} 

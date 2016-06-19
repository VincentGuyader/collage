prodgrille <- function(liste, lig, col, verbose = TRUE, affich = TRUE) {
    if (verbose) {
        message(paste("    lecture "))
    }
    test <- lapply(mapply(seq, seq(1, lig * col, by = lig), seq(col, lig * col, by = col), SIMPLIFY = FALSE), funccolle2,
        liste = liste)


    if (verbose) {
        message(paste("    collage "))
    }

     # trouver un moyen de gerer ca en ram quand on est au max.
    # passage sur disque ?

    test <- abind::abind(test, along = 1)
    if (affich) {
        if (verbose) {
            message(paste("    affichage "))
        }
        # gc()
        plotraster(test, verbose = verbose)
    }
    test
}
# microbenchmark::microbenchmark(prodgrille(liste,lig,col,affich=FALSE),times=8) expr min lq mean median uq max
# neval prodgrille(liste, lig, col, affich = FALSE) 7.169118 7.195857 7.236903 7.211931 7.257568 7.395396 8

# microbenchmark::microbenchmark(abind::abind(test,along=1),times=8) expr min lq mean median uq max neval
# abind::abind(test, along = 1) 4.135301 4.161878 4.184652 4.188135 4.212134 4.217619 8
funccolle2 <- function(rang, liste) {
    abind::abind(liste[rang], along = 2)
}

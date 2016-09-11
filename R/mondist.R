# -*- coding: utf-8 -*-
#' @encoding UTF-8
#' @title mondist
#' @description  fonction qui calcule la distance d'un point par raport à un autre ensemble de points.
#' @param X coordonnée du point
#' @param B coordonnée des points de la base
#' @examples
#' \dontrun{
#' X<-matrix(c(0.5,0.5,0.5))
#' B<-t(matrix(round(runif(9),2),3))
#' mondist(X,B)
#' }

mondist <- function(X, B) {
    sqrt(colSums(matrix((as.vector(X) - as.vector(B))^2, 3)))
}

#' @title mondist_global
#' @description  fonction qui calcule la distance d'un ensemble de points par raport à un autre ensemble de points.
#' @param lesX les points dont on cherche la distance par rappoirt à la base
#' @param B coordonnée des points de la base
#' @param paralell booleen si VRAI alors le multiprocessing est utilisé
#' @param thread nombre de coeurs à utiliser
#' @param verbose booleen qui rend la fonction bavarde
#' @examples
#' \dontrun{
#' X<-matrix(c(0.5,0.5,0.5))
#' lesX<-do.call(rbind,(rep(list(t(X)),15)))
#' B<-t(matrix(round(runif(12),2),3))
#' system.time(mondist_global(lesX,B))
#' system.time(mondist_global(lesX,B,paralell=TRUE,thread=2))
#' }

mondist_global <- function(lesX, B, paralell = FALSE, thread = 2,verbose=TRUE) {
    lesX <- as.matrix(lesX)
    if (thread == 1) {
        paralell <- FALSE
    }

    if (!paralell) {
        out <- foreach(i = 1:nrow(lesX)) %do% {

            # sqrt(colSums(matrix((as.vector(lesX[i, ]) - as.vector(t(B)))^2,3)))
            sqrt(colSums(matrix((as.vector(lesX[i, ]) - as.vector(B))^2, 3)))

        }
    } else if (paralell) {
if (verbose) { message(thread," threads utilisés")}
        # if (getDoParWorkers() != thread) {
        cl <- snow::makeCluster(thread, type = "SOCK")
        doSNOW::registerDoSNOW(cl)
        # }
        suppressWarnings(range <- split(1:nrow(lesX), rep(1:thread, each = round(nrow(lesX)/thread))))
        out <- foreach::foreach(i = range, .export = "mondist_global", .packages = "foreach") %dopar% {
            mondist_global(lesX[i, ], B, paralell = FALSE,verbose=FALSE)
        }
        snow::stopCluster(cl)
    }
    do.call(rbind, out)

}

# -*- coding: utf-8 -*-
#' @title mondist
#' @description  fonction qui calcule la distance d 'un point par raport a un autre ensemble de point.
#' @param X coordonnée du point
#' @param B coordonnée des points de la base
#' @examples
#' X<-matrix(c(0.5,0.5,0.5))
#' B<-t(matrix(round(runif(9),2),3))
#' mondist(X,B)

mondist <- function(X, B) {
  sqrt(colSums(matrix((as.vector(X) - as.vector(B))^2, 3)))
}

#' @title mondist_global
#' @description  fonction qui calcule la distance d 'un ensemble de points par raport a un autre ensemble de point.
#' @param lesX les point dont on cherche la distance par rappoirt à la base
#' @param B coordonnée des points de la base
#' @param paralell booleen si VRAI alors le multiprocessing est utilisé
#' @param threat nombre de coeurs a utiliser
#' @examples
#' lesX<-do.call(rbind,(rep(list(t(X)),15)))
#' B<-t(matrix(round(runif(12),2),3))
#' system.time(mondist_global(lesX,B))
#' system.time(mondist_global(lesX,B,paralell=TRUE,threat=2))

mondist_global <- function(lesX, B, paralell = FALSE, threat = 2) {
  lesX<- as.matrix(lesX)
  if (threat == 1) {
    paralell <- FALSE
  }

  if (!paralell) {
    out <- foreach(i = 1:nrow(lesX)) %do% {

      # sqrt(colSums(matrix((as.vector(lesX[i, ]) - as.vector(t(B)))^2,3)))
      sqrt(colSums(matrix((as.vector(lesX[i, ]) - as.vector(B))^2,3)))

      }
  } else if (paralell) {

    # if (getDoParWorkers() != threat) {
      cl <- snow::makeCluster(threat, type = "SOCK")
      doSNOW::registerDoSNOW(cl)
    # }
      suppressWarnings( range <- split(1:nrow(lesX), rep(1:threat, each = round(nrow(lesX)/threat))))
                         out <- foreach::foreach(i = range, .export = "mondist_global",
      .packages = "foreach") %dopar% {
      mondist_global(lesX[i, ], B, paralell = FALSE)
    }
    snow::stopCluster(cl)
  }
  do.call(rbind,out)

}

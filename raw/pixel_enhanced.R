# -*- coding: utf-8 -*-
#' @encoding UTF-8
#' @title pixel_enhanced
#' @description fonction a lancer
#' @param file fichier jpg d origine a decouper
#' @param lig nombre de ligne
#' @param col nombre de colonne
#' @param base la base de tuile a utiliser
#' @param target fichier de sortie
#' @param parallel si oui le calcul en parallel sera utilisé
#' @param threat nombre de coeur a utilisé si parallel =TRUE
#' @param doublon si FAUX on supprime les doublon avant de calculer les distances
#' @param open si VRAI le fichier target est ouvert en fin de creation
#' @param verbose si VRAI rend la fonction bavarde
#' @param redim utile si la base ne contient pas les images perchargée, precise les dimension des tuiles
#' @param affich booleen si vrai le resultat est affiché en tant que graphique dans R
#' @param random tire au hasard la vignette parmi les meilleur tuiles disponible, random precise ce nombre
#' @examples
#' ## Not run:
#' library(tipixel)
#' lescomb<-expand.grid(a1=seq(0,1,0.15),a2=seq(0,1,0.15),a3=seq(0,1,0.15))
#' genere_tuiles(lescomb,dossier='my_pict')
#' base <- file.path(find.package('tipixel'),'base')
#' img <- sample(list.files(base,full.names = TRUE),1)
#' les_tuiles <- genre_base(base,redim=c(25,25))
#' les_tuiles2 <- genre_base('my_pict',redim=c(25,25))
#' pixel(file=img,lig=5,col=5,base=les_tuiles,target='dessin.jpg',open=TRUE,affich = TRUE)
#' pixel(file=img,lig=50,col=50,base=les_tuiles,target='dessin2.jpg',open=TRUE)
#' pixel(file=img,lig=100,col=100,base=les_tuiles,target='dessin3.jpg',open=TRUE)
#' pixel(file=img,lig=100,col=100,base=les_tuiles2,target='dessin4.jpg',open=TRUE)
#' pixel(file=img,lig=200,col=200,base=les_tuiles,target='dessin4.jpg'
#' ,open=TRUE,parallel = TRUE,threat = 2)
#' ## End(Not run)

#' @export
# pixel_enhanced(file=img,lig=50,col=50,base=les_tuiles,target='dessin2.jpg',open=TRUE)
# file=img;lig=200;col=200;base=les_tuiles;target='dessin4.jpg'
# open=TRUE;parallel = TRUE;threat = 2

pixel_enhanced <- function(file, lig, col, base, target = NULL, parallel = FALSE, threat = 2, open = FALSE, verbose = TRUE, affich = FALSE,
                  doublon = FALSE, redim = NULL,random=1) {
  if (verbose) {
    message("chargement de l'image")
  }
  img <- jpeg::readJPEG(file)
  if (verbose) {
    message(paste("découpage de l'image en ", lig, " x ", col))
  }
  test <- decoupsynth(img = img, lig = lig, col = col)$tab

  test$nom <- as.character(test$nom)

  if (!doublon) {
    if (verbose) {
      message(paste("suppression doublon..."))
    }
    test_orig <- test
    test <- test[!duplicated(test$html), ]  # a voir si c 'est mieux ou différent avec RVB
  }
  if (verbose) {
    message(paste("calcul des distances..."))
  }




  BONdist <- mondist_global(test[, c("R", "G", "B")], t(base$base[, c("R", "G", "B")]), parallel = parallel, threat = threat)
  colnames(BONdist) <- base$base$nom
  rownames(BONdist) <- test$nom




  if (verbose) {
    message(paste("fin calcul distance"))
  }
  if (verbose) {
    message(paste("calcul table correspondance"))
  }
  # browser()
  if ( random <=1){
    corresp <- cbind(test, pict = colnames(BONdist)[sapply(as.data.frame(t(BONdist)), which.min)])
  }else{
    corresp <- cbind(test, pict = colnames(BONdist)[sapply(as.data.frame(t(BONdist)), function(x){
      sample(order(x)[1:random],1)
    })])

  }


  if (!doublon) {
    if (verbose) {
      message(paste("recompose doublon..."))
    }

    corresp <- merge(test_orig, corresp, by = c("html"), all.x = TRUE)
    corresp <- corresp[order(as.numeric(corresp$nom.x)), ]
  }



  if (verbose) {
    message(paste("preparation plot"))
  }
  # print(dim(corresp))

  if (!is.na(base$read)) {
    if (verbose) {
      message(paste("   lecture depuis base"))
    }

    liste <- base$read[as.character(corresp$pict)]

  } else {
    if (verbose) {
      message(paste("   lecture depuis fichiers"))
    }

    tout <- plyr::llply(as.character(levels(corresp$pict)), .fun = decoupsynthpath, redim = redim, verbose = verbose,
                        .progress = "text", preload = TRUE)
    names(tout) <- as.character(levels(corresp$pict))
    lesREAD <- lapply(tout, FUN = function(x) {
      x$read
    })
    liste <- lesREAD[as.character(corresp$pict)]


  }
  if (verbose) {
    message(paste("reconstruction image "))
  }
  out <- aperm(prodgrille(liste, lig, col, verbose = verbose, affich = affich), c(2, 1, 3))

  if (length(target) != 0) {
    if (verbose) {
      message(paste("export dans ", target))
    }
    jpeg::writeJPEG(out, target = target, quality = 1)
    if (open) {
      if (verbose) {
        message(paste("ouverture de", target))
      }

      browseURL(target)
    }
  }
  if (verbose) {
    message(paste(" FIN "))
  }
  invisible(list(img = out, corresp = corresp))
}

# -*- coding: utf-8 -*-
#' @importFrom grDevices dev.off
#' @importFrom graphics par plot rasterImage
#' @importFrom stats na.omit setNames
#' @importFrom utils browseURL packageDescription
#' @encoding UTF-8
#' @title pixel
#' @description fonction générale du package. Permet de transformer une image en mosaique d'autres images
#' @param file fichier jpg d'origine à découper
#' @param lig nombre de lignes
#' @param col nombre de colonnes
#' @param base la base de tuile à utiliser
#' @param target fichier de sortie en jpg
#' @param paralell si oui le calcul en paralell sera utilisé
#' @param thread nombre de coeur à utiliser si paralell =TRUE
#' @param doublon si FAUX on supprime les doublons avant de calculer les distances
#' @param open si VRAI le fichier target est ouvert en fin de création
#' @param verbose si VRAI rend la fonction bavarde
#' @param redim utile si la base ne contient pas les images perchargées, précise les dimensions des tuiles
#' @param affich booleen si vrai le resultat est affiché en tant que graphique dans R
#' @param random tire au hasard la vignette parmi les meilleurs tuiles disponibles, random precise ce nombre
#' @examples
#' \dontrun{
#' library(tipixel)
#' lescomb<-expand.grid(a1=seq(0,1,0.15),a2=seq(0,1,0.15),a3=seq(0,1,0.15))
#' genere_tuiles(lescomb,dossier='my_pict')
#' base <- file.path(find.package('tipixel'),'base')
#' img <- sample(list.files(base,full.names = TRUE),1)
#' plotraster(aperm(jpeg::readJPEG(img),c(2,1,3)))
#' les_tuiles <- genere_base(base,redim=c(25,25))
#' les_tuiles2 <- genere_base('my_pict')
#' pixel(file=img,lig=5,col=5,base=les_tuiles,target='dessin.jpg',open=TRUE,affich = TRUE)
#' pixel(file=img,lig=50,col=50,base=les_tuiles,target='dessin2.jpg',open=TRUE)
#' pixel(file=img,lig=100,col=100,base=les_tuiles,target='dessin3.jpg',open=TRUE)
#' pixel(file=img,lig=100,col=100,base=les_tuiles2,target='dessin4.jpg',open=TRUE)
#' pixel(file=img,lig=200,col=200,base=les_tuiles,target='dessin4.jpg'
#' ,open=TRUE,paralell = TRUE,thread = 2)
#' }

#' @export

pixel <- function(file, lig, col, base, target = NULL, paralell = FALSE, thread = 2, open = FALSE, verbose = TRUE, affich = FALSE,
    doublon = FALSE, redim = NULL,random=1) {
    if (verbose) {
        message("chargement de l'image")
    }
    img <- jpeg::readJPEG(file)

    # on va cacluler les lig et col optimale si on ne nous passe pas le truc en entier
    # il faut que les dimensions des tuiles soient la memes
    # nrow(img)/ncol(img)
    # nrow(img)/lig
    #
    # dim(img)
    if (missing(lig) & missing(col)){
      stop("nedd lig and/or col")
    }


    if (missing(redim)){
      dim_tuile <- base$redim

    }else{
      dim_tuile <- redim
    }

# ca ca marche bien si tuiles carrées
    if (missing(lig) & !missing(col)){
        lig<- round(col*nrow(img)/ncol(img))
        lig <- round(lig * (dim_tuile[1]/dim_tuile[2]))
    }

    if (!missing(lig) & missing(col)){
      col<- round(lig*ncol(img)/nrow(img))
      col <- round(col * (dim_tuile[2]/dim_tuile[1]))
    }


#


    # si tuile 2 fois moins large, il en faut 2 fois plus




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




    BONdist <- mondist_global(test[, c("R", "G", "B")], t(base$base[, c("R", "G", "B")]), paralell = paralell, thread = thread)
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
suppressWarnings(flag <-!is.na(base$read))
    if (flag[1]) {
        if (verbose) {
            message(paste("   lecture depuis base"))
        }
# browser()

# names(base$read)


if ( !setequal(dim_tuile,base$redim)){

  if (verbose) {
    message(paste("   redimensionnement des tuiles de la base"))
  }

base_redim <- base$read[unique(as.character(corresp$pict))]
base_redim<-plyr::llply(base_redim,resize,25,25,.progress = "text")
liste <- base_redim[as.character(corresp$pict)]
}else{
  liste <- base$read[as.character(corresp$pict)]

}
        # redimensioner a la volé ce truc



    } else {
        if (verbose) {
            message(paste("   lecture depuis fichiers"))
        }

        tout <- plyr::llply(as.character(levels(corresp$pict)), .fun = decoupsynthpath,
                            redim = redim, verbose = verbose,
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
# browser()
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

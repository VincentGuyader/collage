#' A base of kittens
#'
#' @examples
#'   kittens
"kittens"


# -*- coding: utf-8 -*-
#' @encoding UTF-8
#' @title kittenize
#' @description Pou ceux qui aiments les chatons
#' @param file fichier jpg d'origine à découper
#' @param lig nombre de lignes
#' @param col nombre de colonnes
#' @param target fichier de sortie en jpg
#' @param parallel si oui le calcul en parallel sera utilisé
#' @param thread nombre de coeur à utiliser si parallel =TRUE
#' @param doublon si FAUX on supprime les doublons avant de calculer les distances
#' @param open si VRAI le fichier target est ouvert en fin de création
#' @param verbose si VRAI rend la fonction bavarde
#' @param redim utile si la base ne contient pas les images perchargées, précise les dimensions des tuiles
#' @param affich booleen si vrai le resultat est affiché en tant que graphique dans R
#' @param random tire au hasard la vignette parmi les meilleurs tuiles disponibles, random precise ce nombre
#'
#' @examples
#' \dontrun{
#' library(tipixel)
#'
#' kittenize(sample_image())
#' }

#' @export
kittenize <- function(file, lig=100,col, target = "kitten.jpg", parallel = FALSE,
                      thread = 2, open = TRUE, verbose = TRUE, affich = FALSE,
                      doublon = FALSE, redim = NULL, random = 1){

  base <- paste0(file.path(find.package('tipixel'),'base'),"/basechaton.RDS")
  chatons <<- readRDS(base)
  print(chatons)


 pixel(file, lig=lig, col=col, base=chatons, target = target, parallel = parallel,
   thread = thread, open = open, verbose = verbose, affich = affich,
   doublon = doublon, redim = chatons$redim, random = random)


}


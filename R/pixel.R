# -*- coding: utf-8 -*-
#' @title pixel
#' @description fonction a lancer
#' @param file fichier d origine a decouper
#' @param lig nombre de ligne
#' @param col nombre de colonne
#' @param base la base de tuile a utiliser
#' @param target fichier de sortie
#' @examples
#' ## Not run:
#' lescomb<-expand.grid(a1=seq(0,1,0.15),a2=seq(0,1,0.15),a3=seq(0,1,0.15))
#' genere_tiles(lescomb,dossier="base")
#' les_tuiles <- genre_base("base",redim=c(25,25))
#' les_tuiles
#' A3<-pixel(file="plot.jpg",lig=5,col=5,base=les_tuiles)
#' A<-pixel(file="plot.jpg",lig=50,col=50,base=les_tuiles,target="dessin.jpg")
#' A<-pixel(file="plot.jpg",lig=100,col=100,base=les_tuiles,target="dessin2.jpg")
#' ## End(Not run)

#' @export

# file="646_220.jpg";lig=200;col=200;base=les_tuiles;target="dessin3a.jpg"
pixel<-function(file,lig,col,base,target=NULL,paralell=FALSE,threat=2,open=TRUE,verbose=TRUE,affich=FALSE,doublon=FALSE){
 if (verbose){ message("chargement de l'image")}
  img<-jpeg::readJPEG(file)
  if (verbose){ message(paste("découpage de l'image en ",lig," x ",col))}
  test<-decoupsynth(img=img,lig=lig,col=col)$tab
  # TODO GERER DOUBLON, puis jointure

  test$nom<-as.character(test$nom)

if ( !doublon){
  if (verbose){ message(paste("suppression doublon..."))}
  test_orig<-test
  test<-test[!duplicated(test$html),] # a voir si c 'est mieux ou différent avec RVB
}
  if (verbose){ message(paste("calcul des distances..."))}




    BONdist<-mondist_global(test[,c("R","G","B")],t(base$base[,c("R","G","B")]),paralell=paralell,threat=threat)
    colnames(BONdist) <- base$base$nom
    rownames(BONdist) <- test$nom




if (verbose){ message(paste("fin calcul distance"))}
    if (verbose){ message(paste("calcul table correspondance"))}
corresp<-cbind(test,pict=colnames(BONdist)[sapply(as.data.frame(t(BONdist)),which.min)])
if ( !doublon){
  if (verbose){ message(paste("recompose doublon..."))}

  corresp<-merge(test_orig,corresp,by=c("html"),all.x=TRUE)
  corresp<-corresp[order(as.numeric(corresp$nom.x)),]
}



if (verbose){ message(paste("preparation plot"))}
  # print(dim(corresp))
  liste<-    base$read[as.character(corresp$pict)]
  if (verbose){ message(paste("reconstruction image "))}
  out<-aperm(prodgrille(liste,lig,col,verbose=verbose,affich=affich),c(2,1,3))

  if (length(target)!=0){
    if (verbose){ message(paste("export dans ",target))}
    jpeg::writeJPEG(out, target=target, quality=1)
    if (open){
      if (verbose){ message(paste("ouverture de",target))}

      browseURL(target)}
  }
  if (verbose){ message(paste(" FIN "))}
  invisible(list(img=out,corresp=corresp))
}

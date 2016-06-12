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
#'
#' A3<-pixel(file="plot.jpg",lig=5,col=5,base=les_tuiles)
#' A<-pixel(file="plot.jpg",lig=50,col=50,base=les_tuiles,target="dessin.jpg")
#' ## End(Not run)

#' @export


pixel<-function(file,lig,col,base,target=NULL){
  # on enchaine tout
  img<-jpeg::readJPEG(file)
  test<-decoupsynth(img=img,lig=lig,col=col)$tab
  test$nom<-as.character(test$nom)
  print("debut calcul distance (etape optimisable) penser vectorisation")

  # V1
  V1<-function(){
    lesbase<-base$base[,c("R","G","B")]
    rownames(lesbase)<-base$base$nom
    lestruc<-test[,c("R","G","B")]
    OK<-apply(lesbase,MARGIN=1,mondist,lestruc)
    return(OK)
  }
  # V2
  V2<-function(){
    prdist<-rbind(base$base,test)
    rownames(prdist)<-prdist[,1]
    lesnoms<-prdist[,1]
    prdist<-as.matrix(prdist[,4:6])
    lesdist<-as.matrix(dist(prdist))
    BONdist<-lesdist[test$nom,setdiff(colnames(lesdist),test$nom)]
    return(BONdist)
  }
  dim(base$base)
  # library(rbenchmark)
  # benchmark(oo<-V2(),ss<-V1(),replications = 100)
  #  "7000"
  if ( nrow(base$base)>7000){
    V2()->BONdist
  }else{
    V2()->BONdist
  }
  print("fin calcul distance")

  corresp<-cbind(test,pict=apply(test,MARGIN=1,FUN=function(vec){names(which.min(BONdist[rownames(BONdist)==vec$nom,]))}))

  print("on plot")
  print(dim(corresp))
  # plotcorresp(corresp,img,lesread=base$read)

  #     return(list(corresp=corresp,img=img,lesread=base$read))
  #     plotcorresp(corresp,img,lesread=base$read)

  liste<-    base$read[as.character(corresp$pict)]
  # base$read["base/base-1-1-0.45.jpg"]
  # out<-t_array(prodgrille(liste,lig,col))
  out<-aperm(prodgrille(liste,lig,col),c(2,1,3))

  # out<-prodgrille(liste,lig,col)

  if (length(target)!=0){
    print(target)
    jpeg::writeJPEG(out, target=target, quality=1)
    browseURL(target)
  }

  return(list(img=out,corresp=corresp))
}

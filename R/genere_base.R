# -*- coding: utf-8 -*-
#' @title genre_base
#' @description li le contenu du dossier de tuiles et genere un objet base
#' @param chemin le chemin du dosier de tuiles
#' @param redim permet de redimensionner les tuiles
#' @examples les_tuiles <- genre_base("base",redim=c(25,25))
#'
#' @export


genre_base<-function(chemin="base",redim=NULL){
  # on va parcourir chaque image et faire un mycoul
  # faut stocker l import readjpg
  # trop long, le decoupsynthpth est trop longpour un simple truc comme ca.
  # ou alors la vectorisation ne fonctionn pas pour une chose etrange.
  print("A")
  nom<-list.files(chemin,full.names = TRUE)
  # decoupsynthpath(nom[[1]])
  # peut etre qu'il est plus rentable de tout lire, en une passe, puis comme il n ya plus de osucis de disque, de faire les redim
  tout<-lapply(nom,FUN=decoupsynthpath,lig=1,col=1,redim=redim)
  print("B")
  LABASE<-cbind(nom,do.call(rbind,lapply(tout,FUN=function(x){x$tab}))[,-1])
  LABASE$nom<-as.character(LABASE$nom)
  print("C")
  lesREAD<-lapply(tout,FUN=function(x){x$read})
  print("D")
  #     lesRASTER<-lapply(nom, raster)
  names(lesREAD)<-LABASE$nom
  #     return(list(base=LABASE,read=lesREAD,lesRASTER=lesRASTER))


  # on supprime de LABASE les truc vides
  LABASE$read <-  LABASE$read[!is.na(LABASE$read)]
  LABASE$base<- na.omit(LABASE$base)
  out<-list(base=LABASE,read=lesREAD)
  class(out)<-"unebase"
  return(out)

}

print.unebase<- function(x,...){

  cat( "base de ",nrow(bb$base)," tuiles \n")


}



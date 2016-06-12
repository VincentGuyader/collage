# -*- coding: utf-8 -*-
#' @title genre_base
#' @description li le contenu du dossier de tuiles et genere un objet base
#' @param chemin le chemin du dosier de tuiles
#' @param redim permet de redimensionner les tuiles
#' @examples les_tuiles <- genre_base("base",redim=c(25,25))
#'
#' @export


genre_base<-function(chemin="base",redim=NULL){
  print("A")
  nom<-list.files(chemin,full.names = TRUE)
  tout<-lapply(nom,FUN=decoupsynthpath,redim=redim)
  print("B")
  LABASE<-cbind(nom,dplyr::bind_rows(lapply(tout,FUN=function(x){x$tab}))[,-1])

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
out

}

#' @export
print.unebase<- function(x,...){

  cat( "base de ",nrow(x$base)," tuiles \n")


}



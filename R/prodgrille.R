
prodgrille<-function(liste,lig,col,verbose=TRUE,affich=TRUE){
  if (verbose){ message(paste("    lecture "))}
  test<-lapply(
    mapply(seq,seq(1,lig*col,by=lig),seq(col,lig*col,by=col), SIMPLIFY = FALSE)
    ,funccolle2,liste=liste)


  if (verbose){ message(paste("    collage "))}
  test<-abind::abind(test,along=1)
  if ( affich){
  if (verbose){ message(paste("    affichage "))}
  # gc()
  plotraster(test,verbose=verbose)
  }
  test
}


funccolle2<-function(rang,liste){abind::abind(liste[rang],along=2)}

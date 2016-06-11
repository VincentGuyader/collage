
prodgrille<-function(liste,lig,col){
  print("on prod")
  test<-lapply(
    mapply(seq,seq(1,lig*col,by=lig),seq(col,lig*col,by=col), SIMPLIFY = FALSE)
    ,funccolle2,liste=liste)


  print("on continue")
  # test<-Reduce(colle2r,test)
  test<-abind::abind(test,along=1)
  print("on envoie au plot")
  # gc()
  plotraster(test)
  return(test)
}


funccolle2<-function(rang,liste){abind::abind(liste[rang],along=2)}

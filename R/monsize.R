#' @title monsize
#' @description redim d'une image en array
#' @param chemin le chemin du dosier de tuiles
#' @param redim permet de redimensionner les tuiles
#' @export
#'
#'
#
# load("arr.RData")
# microbenchmark(arr2<-monsize(arr,100,100),times=150)
# # 350/296 sur 15. 433 sur 150

monsize<-function(arr,x,y){
  #     print("debut")
  ss <- raster::raster(ncol=x,  nrow=y)
  arr2<-array(dim=c(x,y,3))
  arr2[,,1]<-bim(arr[,,1],ss)
  arr2[,,2]<-bim(arr[,,2],ss)
  arr2[,,3]<-bim(arr[,,3],ss)
  #     print("fin")
  return(arr2)
}
#     dim(ert<-alply(arr,.margins=3,.fun=bim))

bim<-function(lay,ss){
  tod <-raster::raster(lay)
  raster::extent(tod)<-raster::extent(ss)
  rr <- raster::as.matrix(
    raster::resample(tod, ss)
    )
  return(rr)
}




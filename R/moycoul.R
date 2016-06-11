# -*- coding: utf-8 -*-
#' @title moycoul
#' @description renvoi le code RVB et html moyen d 'une image
#' @param img l 'image (en array)
#' @export


moycoul<-function(img){
  if (is.null(dim(img))){
    val<-img

  }else{
    val<-c(mean(img[,,1]),mean(img[,,2]),mean(img[,,3]))
  }
  return(list(rgb=val,html=grDevices::rgb(val[1],val[2],val[3])))

}

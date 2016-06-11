# -*- coding: utf-8 -*-
#' @title t_array
#' @description transpose un array
#' @export
t_array<-function(ttuc){
  ttuc[,,1]<-t(ttuc[,,1])
  ttuc[,,2]<-t(ttuc[,,2])
  ttuc[,,3]<-t(ttuc[,,3])
  return(ttuc)
}


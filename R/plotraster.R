
plotraster<-function(a){
  #     print("on plot")
  a<-t_array(a)
  ydim <- attributes(a)$dim[1] # Image dimension y-axis
  xdim <- attributes(a)$dim[2] # Image dimension x-axis
  par(bg="white")
  plot(c(0,xdim), c(0,ydim), type='n',xlab="",ylab="",bty="n",axes = FALSE)
  print("masque OK")
  a[a>1]<-1
  rasterImage(a,0,0,xdim,ydim)
  print("plot fait")
}

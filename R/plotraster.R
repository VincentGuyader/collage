
plotraster<-function(a,verbose=TRUE){
  #     print("on plot")
  a<-aperm(a,c(2,1,3))
  ydim <- attributes(a)$dim[1] # Image dimension y-axis
  xdim <- attributes(a)$dim[2] # Image dimension x-axis
  par(bg="white")
  plot(c(0,xdim), c(0,ydim), type='n',xlab="",ylab="",bty="n",axes = FALSE)
  if (verbose){ message(paste("        masque OK "))}
  a[a>1]<-1
  rasterImage(a,0,0,xdim,ydim)
  if (verbose){ message(paste("        plot OK "))}
}

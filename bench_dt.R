library(tipixel)
N<-10
tuil<-5
B2<-matrix(round(runif(N*3),2),3)
grosX<-matrix(round(runif(tuil*tuil*3),2),ncol=3)
rm(SS);system.time(SS<-mondist_global(lesX = grosX,B=B,paralell = FALSE))
rm(SS2);a1<-system.time(SS2<-mondist_global(lesX = grosX,B=B,paralell = TRUE,threat=1))
les_tuiles50b <- genre_base("base50",redim=c(10,10))

mondist_global(grosX,B,paralell=TRUE,threat=3)

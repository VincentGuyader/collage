library(tipixel)
lescomb<-expand.grid(a1=seq(0,1,0.15),a2=seq(0,1,0.15),a3=seq(0,1,0.15))
genere_tiles(lescomb,dossier="base")
les_tuiles2 <- genre_base("base",redim=c(25,25))
microbenchmark::microbenchmark(les_tuiles3 <- genre_base("base",redim=c(100,100)),times = 1)
les_tuiles3 <- genre_base("base3",redim=c(100,100))
les_tuilesb <- genre_base("base",redim=c(10,10))
les_tuiles50b <- genre_base("base50",redim=c(10,10))
les_tuiles50 <- genre_base("base50",redim=c(100,100))
les_tuiles10 <- genre_base("base10",redim=c(100,100))

les_tuiles4 <- genre_base("base")
A3<-pixel(file="plot.jpg",lig=5,col=5,base=les_tuiles2)
A<-pixel(file="plot.jpg",lig=50,col=50,base=les_tuiles2,target="dessin.jpg")
A<-pixel(file="plot.jpg",lig=100,col=100,base=les_tuiles2,target="dessin.jpg")
A<-pixel(file="646_220.jpg",lig=100,col=100,base=les_tuiles2,target="dessin.jpg")

A<-pixel(file="pp.jpg",lig=100,col=100,base=les_tuiles3,target="dessin3a.jpg")
A<-pixel(file="pp.jpg",lig=50,col=50,base=les_tuiles3,target="dessin3a.jpg")
A<-pixel(file="646_220.jpg",lig=15,col=5,base=les_tuiles3,target="dessin3a.jpg")

A<-pixel(file="646_220.jpg",lig=100,col=100,base=les_tuiles4,target="dessin4.jpg")
A<-pixel(file="hadley.jpg",lig=50,col=50,base=les_tuiles50b,target="dessin_hadley.jpg")

A<-pixel(file="hadley.jpg",lig=50,col=50,base=les_tuilesb,target="dessin_hadley2.jpg")
les_tuiles50b

library(microbenchmark)
microbenchmark::microbenchmark(les_tuiles3 <- genre_base("base3",redim=c(100,100)),times=15)
# 2.26 windows 1 fois -> 1.37
# 1.63 gros linux
microbenchmark::microbenchmark(les_tuiles3 <- genre_base("base3"),times=45)
# 209 -> 141 -> 79


A<-pixel(file="646_220.jpg",lig=50,col=50,base=les_tuiles50,target="dessin3a.jpg")
A<-pixel(file="646_220.jpg",lig=10,col=10,base=les_tuiles50,target="dessin3a.jpg")
A<-pixel(file="646_220.jpg",lig=100,col=100,base=les_tuiles50,target="dessin3a.jpg")

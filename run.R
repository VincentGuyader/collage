library(tipixel)
lescomb<-expand.grid(a1=seq(0,1,0.15),a2=seq(0,1,0.15),a3=seq(0,1,0.15))
genere_tiles(lescomb,dossier="base")
les_tuiles2 <- genre_base("base",redim=c(25,25))
les_tuiles3 <- genre_base("base3",redim=c(100,100))

les_tuiles4 <- genre_base("base")
A3<-pixel(file="plot.jpg",lig=5,col=5,base=les_tuiles2)
A<-pixel(file="plot.jpg",lig=50,col=50,base=les_tuiles2,target="dessin.jpg")
A<-pixel(file="plot.jpg",lig=100,col=100,base=les_tuiles2,target="dessin.jpg")
A<-pixel(file="646_220.jpg",lig=100,col=100,base=les_tuiles2,target="dessin.jpg")

A<-pixel(file="646_220.jpg",lig=100,col=100,base=les_tuiles3,target="dessin3a.jpg")

A<-pixel(file="646_220.jpg",lig=5,col=5,base=les_tuiles3,target="dessin3a.jpg")

A<-pixel(file="646_220.jpg",lig=100,col=100,base=les_tuiles4,target="dessin4.jpg")

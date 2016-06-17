system.time(A<-pixel(file="plot.jpg",lig=100,col=100,base=les_tuiles,target="dessin2.jpg"))
system.time(A<-pixel(file="plot.jpg",lig=100,col=100,base=les_tuiles,target="dessin2.jpg",paralell = TRUE,threat = TRUE))



system.time(pixel(file="646_220.jpg",lig=100,col=100,base=les_tuiles,target="dessin2.jpg"))
system.time(pixel(file="646_220.jpg",lig=100,col=100,base=les_tuiles,target="dessin2.jpg",paralell = TRUE,threat = 2))

rm(A,A3)
load("grosnichon.RData")
/home/vincent/Documents/nichon/
  les_tuiles <- genre_base("/home/vincent/Documents/nichon/",redim=c(50,50))
# 90
system.time(pixel(file="646_220.jpg",lig=200,col=200,base=les_tuiles,target="dessin2.jpg"))
system.time(pixel(file="646_220.jpg",lig=200,col=200,base=les_tuiles,target="dessin2.jpg",paralell = TRUE,threat = 2))
system.time(pixel(file="pp.jpg",lig=220,col=220,base=les_tuiles,target="dessin2g.jpg",paralell = TRUE,threat = 2))
system.time(pixel(file="pp.jpg",lig=200,col=200,base=les_tuiles,target="dessin2ni2.jpg",paralell = TRUE,threat = 2))
system.time(pixel(file="pp.jpg",lig=100,col=100,base=les_tuiles,target="dessin2ni3.jpg",paralell = TRUE,threat = 2))

system.time(pixel(file="hadley.jpg",lig=200,col=200,base=les_tuiles,target="hadley3.jpg",paralell = TRUE,threat = 2))



ta<-system.time(A<-pixel(file="pp.jpg",lig=100,col=100,base=les_tuiles,target="dessin2ni3.jpg",paralell = TRUE,threat = 2,doublon=FALSE,affich = FALSE))
tb<-system.time(B<-pixel(file="pp.jpg",lig=100,col=100,base=les_tuiles,target="dessin2ni3.jpg",paralell = TRUE,threat = 2,doublon=TRUE,affich = FALSE))
setequal(A,B)

library(tipixel)
ta<-system.time(pixel(file="hadley.jpg",lig=220,col=220,base=les_tuiles,target="dessin2ni3.jpg",paralell = TRUE,threat = 2,doublon=FALSE,affich = FALSE))
tb<-system.time(pixel(file="hadley.jpg",lig=220,col=220,base=les_tuiles,target="dessin2ni3.jpg",paralell = TRUE,threat = 2,doublon=TRUE,affich = FALSE))
setequal(A,B)

x<-150
microbenchmark::microbenchmark(pixel(file="hadley.jpg",lig=x,col=x,base=les_tuiles,target="dessin2ni3.jpg",paralell = TRUE,threat = 2,doublon=TRUE,affich = FALSE,open=FALSE),
                               pixel(file="hadley.jpg",lig=x,col=x,base=les_tuiles,target="dessin2ni3.jpg",paralell = TRUE,threat = 2,doublon=FALSE,affich = FALSE,open = FALSE),times = 5)

system.time(A<-pixel(file="plot.jpg",lig=100,col=100,base=les_tuiles,target="dessin2.jpg"))
system.time(A<-pixel(file="plot.jpg",lig=100,col=100,base=les_tuiles,target="dessin2.jpg",paralell = TRUE,threat = TRUE))



system.time(pixel(file="646_220.jpg",lig=100,col=100,base=les_tuiles,target="dessin2.jpg"))
system.time(pixel(file="646_220.jpg",lig=100,col=100,base=les_tuiles,target="dessin2.jpg",paralell = TRUE,threat = 2))

rm(A,A3)
save(les_tuiles,file="les_tuiles.RData")
# 90
system.time(pixel(file="646_220.jpg",lig=200,col=200,base=les_tuiles,target="dessin2.jpg"))
system.time(pixel(file="646_220.jpg",lig=200,col=200,base=les_tuiles,target="dessin2.jpg",paralell = TRUE,threat = 2))

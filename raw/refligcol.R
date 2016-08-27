library(tipixel)
chaton <- genere_base("/home/vincent/Documents/chaton/",redim=c(25,90))
save(chaton,file="chaton.RData")
load("chaton.RData")
 pixel(file="/home/vincent/Documents/Vincent/Mes Photos/les_filles.jpeg",target="OUT.jpg",lig=60,col=60,paralell = TRUE,open=TRUE,base=chaton)
 pixel(file="/home/vincent/Documents/Vincent/Mes Photos/les_filles.jpeg",target="OUT.jpg",lig=3,col=6,paralell = TRUE,open=TRUE,base=chaton)

 pixel(file="/home/vincent/Documents/Vincent/Mes Photos/les_filles.jpeg",target="OUT3.jpg",lig=100,col=178,paralell = TRUE,open=TRUE,base=chaton)

# qd 100x100 ca trace mais pas qand 60 x 100 !!!!!!!

dim(jpeg::readJPEG("/home/vincent/Documents/Vincent/Mes Photos/les_filles.jpeg"))
230 x 408
les v
les tuiles sont carrée, donc c 'est simple'

lig/col == 230/408

60*408/230
100*408/230

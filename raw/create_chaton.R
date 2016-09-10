library(XML)
for ( i in 40:999){
url<-(paste0('http://www.photos-animaux.com/photos,bebe,chats;',i,'.html'))
print(url)
BASE<-XML::htmlParse(url)
liste <-unlist(XML::getNodeSet(BASE, "//img/@src"))
liste <- liste[sapply(liste,FUN=grepl,pattern=".jpg")]
for ( chemin in liste){
  o<-strsplit(chemin,"/")[[1]]
  out<-o[length(o)]
download.file(quiet=TRUE,chemin,destfile = paste0("/mnt/docs/big/chaton/",out),mode = 'wb')
}
}

#  library(tipixel)
#  genere_base(chemin = "/home/vincent/Documents/chaton/",preload = FALSE)->chaton_leger
# # pixel
#  img <- sample(list.files("/home/vincent/Documents/chaton/",full.names = TRUE),1)
#  dim(jpeg::readJPEG("romain.jpg"))
#  100*661/960
#  pixel(file="romain.jpg",lig=40,base=chaton,target='dessin3.jpg',open=TRUE,redim=c(25,50))
#  pixel(file="romain.jpg",col=40,base=chaton,target='dessin3.jpg',open=TRUE)#,redim=c(25,50))
#  #

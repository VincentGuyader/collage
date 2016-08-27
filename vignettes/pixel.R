## ----eval=FALSE----------------------------------------------------------
#  library(tipixel)
#  base <- file.path(find.package('tipixel'),'base') # identifier le chemin de stockage de la base
#  les_tuiles <- genere_base(base,redim=c(100,100),progress = "text")
#  les_tuiles
#  

## ----eval=FALSE----------------------------------------------------------
#  saveRDS(les_tuiles,"mes_tuiles.rds")
#  les_tuiles <- readRDS("mes_tuiles.rds")

## ----eval=FALSE----------------------------------------------------------
#  les_tuiles_non_charge <- genere_base(base,redim=c(100,100),preload = FALSE,progress = "text")
#  les_tuiles_non_charge
#  

## ----eval=FALSE----------------------------------------------------------
#  img <- base::sample(x=list.files(base,full.names = TRUE),size=1) # une image au hasard
#  print(img)
#  plotraster(aperm(jpeg::readJPEG(img),c(2,1,3)))# permet d'afficher l'image en tant que graphique dans une fenêtre de plot

## ----eval=FALSE----------------------------------------------------------
#  
#  pixel(file=img,lig=5,col=5,base=les_tuiles,target='dessin.jpg',affich = TRUE)
#  pixel(file=img,lig=50,col=50,base=les_tuiles,target='dessin2.jpg',affich=TRUE)
#  

## ----eval=FALSE----------------------------------------------------------
#  
#  pixel(file=img,lig=100,col=100,base=les_tuiles,target='dessin4.jpg' ,open=TRUE,paralell = TRUE,thread = 2)
#  

## ----eval=FALSE----------------------------------------------------------
#  
#  pixel(file=img,lig=50,col=50,base=les_tuiles_non_charge,target='dessin5.jpg' ,open=TRUE,paralell = TRUE,thread = 2,redim = c(20,20))
#  

## ----eval=FALSE----------------------------------------------------------
#  
#  pixel(file=img,lig=100,col=100,base=les_tuiles_non_charge,target='dessin6.jpg' ,open=TRUE,paralell = TRUE,thread = 2,doublon=TRUE,random=2)
#  


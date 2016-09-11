

#' @export
liste_unebase <- function(){

  memoire<-ls(envir=.GlobalEnv)
if(length(memoire)!=0){
  return(memoire[sapply(memoire,function(k){inherits((eval(parse(text=k))),"unebase")})])
}else{return(NULL)}
}

#' @export
calc_dim <- function(col,lig,redim,dim){

    dim_tuile <- redim
if (!is.na(lig)){    if(lig==0){lig<-NA}}
    if (!is.na(col)){    if(col==0){col<-NA}}
  # ca ca marche bien si tuiles carrées
  if (is.na(lig) & !is.na(col)){
    lig<- round(col*dim[1]/dim[2])
    lig <- round(lig * (dim_tuile[1]/dim_tuile[2]))
  }
  if (!is.na(lig) & is.na(col)){

    print(dim_tuile)
    print(dim_tuile[1])
    print(dim_tuile[2])

    col<- round(lig*dim[2]/dim[1])
    col <- round(col * (dim_tuile[2]/dim_tuile[1]))
  }





  lig*col
}
#' @export
do <-function(todo){
  eval(parse(text=todo))
}

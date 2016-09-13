
# assumptions: tiles are square of all the same sizes. this can be the job of genere_base

auto_dim <- function( img, width = NA, height = NA ){
  nr <- nrow(img)
  nc <- ncol(img)
  ratio <- nc / nr

  if( is.na(width) && is.na(height) ){
    height <- 100
    width  <- round(height / ratio)
  } else if(is.na(width) ){
    width <- round( height / ratio )
  } else if(is.na(height)){
    height <- round( width * ratio)
  }
  c( width, height )

}

#' @importFrom jpeg readJPEG
pixel2 <- function(file, base, width=NA, height=NA ) {
  img  <- readJPEG(file)
  dims <- auto_dim(img, width, height)

  test <- decoupsynth(img = img, lig = lig, col = col)$tab

  test$nom <- as.character(test$nom)

  if (!doublon) {
    test_orig <- test
    test <- test[!duplicated(test$html), ]  # a voir si c 'est mieux ou différent avec RVB
  }

  BONdist <- mondist_global(test[, c("R", "G", "B")], t(base$base[, c("R", "G", "B")]), parallel = parallel, thread = thread,verbose=verbose)
  colnames(BONdist) <- base$base$nom
  rownames(BONdist) <- test$nom




    corresp <- cbind(test, pict = colnames(BONdist)[sapply(as.data.frame(t(BONdist)), which.min)])

  if (!doublon) {
    corresp <- merge(test_orig, corresp, by = c("html"), all.x = TRUE)
    corresp <- corresp[order(as.numeric(corresp$nom.x)), ]
  }

  suppressWarnings(flag <-!is.na(base$read))
  if (flag[1]) {
    if (verbose) {
      message(paste("   lecture depuis base"))
    }
    if ( !setequal(dim_tuile,base$redim)){

      base_redim <- base$read[unique(as.character(corresp$pict))]
      base_redim<-llply(base_redim,resize,25,25,.progress = "tk")
      liste <- base_redim[as.character(corresp$pict)]
    }else{
      liste <- base$read[as.character(corresp$pict)]

    }
    # redimensioner a la volé ce truc



  } else {
    tout <- llply(as.character(levels(corresp$pict)), .fun = decoupsynthpath,
                  redim = redim, verbose = verbose,
                  .progress = "tk", preload = TRUE)
    names(tout) <- as.character(levels(corresp$pict))
    lesREAD <- lapply(tout, FUN = function(x) {
      x$read
    })
    liste <- lesREAD[as.character(corresp$pict)]


  }
  out <- aperm(prodgrille(liste, lig, col, verbose = verbose, affich = affich), c(2, 1, 3))

  invisible(list(img = out, corresp = corresp))
}

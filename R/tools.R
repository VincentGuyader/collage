
is_image <- function(img){
  length(dim(img)) == 3L && is.numeric(img) && all(img>=0 & img<=1)
}

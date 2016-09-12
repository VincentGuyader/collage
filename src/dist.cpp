#include <Rcpp.h>
#include <RcppParallel.h>

using namespace Rcpp;

inline double square(double x){
  return x*x;
}

//' calculates distances between pixels from X and pixels from B
//'
//' @param X a data frame with columns R, G and B
//' @param B a data frame with columns R, G and B
//' @examples
//' n <- 200*200
//' X <- data.frame( R = runif(n),  G = runif(n),  B = runif(n) )
//' Y <- data.frame( R = runif(50), G = runif(50), B = runif(50) )
//' system.time( dist_rgb( X, Y) )
// [[Rcpp::export]]
NumericMatrix dist_rgb( DataFrame X, DataFrame B ){

  int nx = X.nrows(), nb = B.nrows() ;
  NumericVector red_x = X["R"], green_x=X["G"], blue_x=X["B"] ;
  NumericVector red_b = B["R"], green_b=B["G"], blue_b=B["B"] ;

  NumericMatrix out = no_init_matrix(nx, nb) ;

  // for( int j=0; j<nb; j++){
  tbb::parallel_for(0, nb, 1, [&](int j){
    // grab rgb for the j'th base image
    double red=red_b[j], green=green_b[j], blue=blue_b[j] ;

    // column where to write
    double* p = out.begin() + j*nx;

    // calculate distances
    for(int i=0; i<nx; i++, p++){
      *p = sqrt( square(red-red_x[i]) + square(green-green_x[i]) + square(blue-blue_x[i]) ) ;
    }

  }) ;

  return out;
}



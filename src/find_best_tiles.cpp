#include "tipixel.h"

inline double square(double x){
  return x*x;
}

IntegerVector get_steps( int n, int size){
  int nchunks = ::ceil((double)n / size)  ;
  IntegerVector out(nchunks+1) ;
  for( int i=0; i<nchunks; i++){
    out[i] = i*size ;
  }
  out[nchunks] = n - 1 ;
  return out ;
}

// [[Rcpp::export]]
IntegerVector find_best_tiles( RawVector img, int size, DataFrame base ){
  IntegerVector dim = img.attr("dim") ;
  int ncol = dim[1], nrow = dim[2] ;

  // the rgb vectors for the base
  RawVector R = base["red"] ;
  RawVector G = base["green"] ;
  RawVector B = base["blue"] ;
  int nbase = R.size() ;

  auto get_distance = [&](int i, double r, double g, double b){
    return square(r-R[i]) + square(g-G[i]) + square(b-B[i]);
  } ;

  IntegerVector row_steps = get_steps( nrow, size ) ;
  int nr = row_steps.size() - 1 ;

  IntegerVector col_steps = get_steps( ncol, size ) ;
  int nc = col_steps.size() - 1 ;

  int n = nr*nc ;
  IntegerVector tiles = no_init(n) ;
  NumericVector distances = no_init(n) ;

  tbb::parallel_for(0, nr, [&](int i){
    int k = i*nc ;
    for(int j=0; j<nc; j++, k++){
      int row_start = row_steps[i] ;
      int row_end = row_steps[i+1] ;

      int col_start = col_steps[j] ;
      int col_end = col_steps[j+1] ;

      double red = 0.0 ;
      double green = 0.0 ;
      double blue = 0.0 ;

      for( int ii=row_start; ii<row_end; ii++){
        Rbyte* p = img.begin() + 4*( ii*ncol + col_start );
        for(int jj=col_start; jj<col_end; jj++, p+=4){
          red += p[0] ;
          green += p[1] ;
          blue += p[2] ;
        }
      }
      int npixels = (row_end-row_start) * (col_end - col_start) ;
      red = red / npixels ;
      green = green / npixels ;
      blue = blue / npixels ;

      double distance = get_distance(0, red, green, blue) ;
      int best = 0 ;

      for(int ii=1; ii<nbase; ii++){
        double current_distance = get_distance(ii, red, green, blue) ;
        if( current_distance < distance ){
          best = ii ;
          distance = current_distance ;
        }
      }

      distances[k] = sqrt( distance / 195075 ) ; // 195075 = 3 * (255)^2
      tiles[k] = best ;

    }
  }) ;
  tiles.attr("distances") = distances ;
  tiles.attr("width")  = nc ;
  tiles.attr("height") = nr ;
  return tiles ;
}

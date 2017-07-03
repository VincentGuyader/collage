#include "tipixel.h"

// [[Rcpp::export]]
RawVector collage( List tiles, int width, int height, IntegerVector best_tiles, int size ){
  int n = 4 * ( width * size ) * ( height * size ) ;
  RawVector out = no_init(n) ;

  // store the tiles into a std::vector of NumericVector so that
  // they can be used in parallel
  std::vector<RawVector> tiles_vector( tiles.begin(), tiles.end() ) ;

  tbb::parallel_for( 0, height, [&](int i){
    int k = i*width ;
    for( int j=0; j<width; j++, k++){    // columns
      // fill the given position with the best tile

      int offset = i * 4 * size * width * size + 4 * j * size ;

      Rbyte* p = tiles_vector[ best_tiles[k] ].begin() ;
      Rbyte* q = out.begin() + offset ;

      // copy each row of the tile into the output's pixel (size*size)
      for( int ii = 0; ii < size; ii++){
        std::copy( p, p + 4 * size, q ) ;
        p += 4 * size ;
        q += 4 * width * size ;
      }
    }
  }) ;
  out.attr("dim") = IntegerVector::create(4, width*size, height*size ) ;
  return out ;

}

inline Rbyte grayscale( double d, double min, double max ){
  Rbyte value ;
  if( d < min ){
    value = 0xff ;
  } else if( d > max ) {
    value = 0 ;
  } else {
    d = 1 - (d - min) / (max - min) ;
    value = (Rbyte)(255*d) ;
  }
  return value ;
}

// [[Rcpp::export]]
RawVector base_mask( NumericVector distances, int width, int height, int size, double min_distance, double max_distance){
  int n = 4 * width * height * size * size ;
  RawVector out = no_init( n) ;

  tbb::parallel_for(0, height, [&](int i){
    int k = i*width;
    for( int j=0; j<width; j++, k++) {
      Rbyte value = grayscale( distances[k], min_distance, max_distance) ;

      for( int ii=0; ii<size; ii++){
        int offset = (i * size + ii ) * (4 * width * size) + 4 * j * size;

        Rbyte* q  = out.begin() + offset ;
        for( int jj=0; jj<size; jj++, q += 4){
          std::fill( q, q + 3, value) ;
          q[3] = 0xff ;
        }
      }
    }
  }) ;

  out.attr("dim") = IntegerVector::create( 4, width*size, height * size ) ;
  return out ;

}

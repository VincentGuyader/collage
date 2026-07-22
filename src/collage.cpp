#include "tipixel.h"

// [[Rcpp::export]]
RawVector collage_impl( List tiles, int width, int height, IntegerVector best_tiles, int size ){
  // R_xlen_t: the mosaic can exceed 2^31 bytes for large images
  R_xlen_t n = 4 * (R_xlen_t)( width * size ) * ( height * size ) ;
  RawVector out = no_init(n) ;

  // store the tiles into a std::vector of NumericVector so that
  // they can be used in parallel
  std::vector<RawVector> tiles_vector( tiles.begin(), tiles.end() ) ;

  // one output pixel row at a time so that writes to `out` are sequential;
  // the tiles being read are small enough to stay in cache
  int out_row = 4 * width * size ;
  tbb::parallel_for( 0, height, [&](int i){
    for( int ii = 0; ii < size; ii++){
      Rbyte* q = out.begin() + (R_xlen_t)(i * size + ii) * out_row ;
      const int* bt = best_tiles.begin() + i * width ;
      for( int j=0; j<width; j++, q += 4 * size){
        const Rbyte* p = tiles_vector[ bt[j] ].begin() + ii * 4 * size ;
        std::copy( p, p + 4 * size, q ) ;
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

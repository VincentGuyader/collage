#include <tipixel.h>

// [[Rcpp::export]]
RawVector collage( List tiles, int width, int height, IntegerVector best_tiles, int size ){

  int pixel_size = size * size ;
  int n = 4 * width * height * pixel_size ;
  RawVector out = no_init(n) ;

  // store the tiles into a std::vector of NumericVector so that
  // they can be used in parallel
  std::vector<RawVector> tiles_vector( tiles.begin(), tiles.end() ) ;

  for( int i=0; i<width; i++){            // rows
    int k = i*height ;
    for( int j=0; j<height; j++, k++){    // columns
      // fill the given position with the best tile

      int offset = 4 * pixel_size * i * width + 4 * j * size ;

      Rbyte* p = tiles_vector[k].begin() ;
      Rbyte* q = out.begin() + offset ;

      // copy each row of the tile into the output's pixel (size*size)
      for( int ii = 0; ii < size; ii++){
        std::copy( p, p + 4*size, q ) ;
        p += 4 * size ;
        q += 4 * width * size ;
      }
    }
  }
  out.attr("dim") = IntegerVector::create(4, width*size, height*size ) ;
  return out ;

}

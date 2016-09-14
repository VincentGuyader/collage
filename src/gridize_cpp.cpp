#include <tipixel.h>

// [[Rcpp::export]]
NumericVector gridize_cpp( NumericVector img, int width, int height, int size, NumericVector rgb, bool mean = false){
  IntegerVector dim = img.attr("dim") ;
  int nrow = dim[0] ;
  int ncol = dim[1] ;

  IntegerVector a_steps = steps(nrow, height) ;
  IntegerVector b_steps = steps(ncol, width) ;

  int out_width  = ncol + size * ( width + 1 );
  int out_height = nrow + size * (height + 1) ;

  NumericVector out = no_init( 3 * out_width * out_height) ;
  out.attr("dim") = IntegerVector::create( out_height, out_width, 3 ) ;

  auto fill_grid = [&](int channel){
    double value = rgb[channel] ;
    double* p = out.begin() + channel * out_height * out_width ;
    double* data = img.begin() + channel * nrow * ncol ;

    int colpos = 0 ;
    for( int j=0; j<width; j++){
      int b_from = b_steps[j], b_to = b_steps[j+1]  ;
      std::fill(p, p + size * out_height, value ) ;

      int ncolumns = b_to - b_from ;
      for( int k=0; k<ncolumns; k++){
        double* q = p + out_height*(size + k) ;
        for( int i=0; i<height; i++){
          std::fill( q, q+size, value ) ;
          q += size + a_steps[i+1] - a_steps[i] ;
        }
        std::fill( q, q+size, value ) ;
      }

      p += out_height * size ;

      int tile_width = b_to-b_from ;

      int rowpos = 0 ;
      for( int i=0; i<height; i++){
        double* data_image = data + colpos * nrow + rowpos ;

        int a_from = a_steps[i], a_to = a_steps[i+1]  ;
        int tile_height = a_to-a_from ;
        double* q = p + rowpos + (i+1) * size  ;

        if( mean ){
          double m = 0.0 ;
          for( int jj=0; jj<tile_width; jj++){
            m = std::accumulate( data_image, data_image + tile_height, m) ;
            data_image += nrow ;
          }
          m = m / (tile_height * tile_width) ;
          for( int jj=0; jj<tile_width; jj++){
            std::fill(q, q+tile_height, m) ;
            q += out_height ;
          }
        } else {
          for( int jj=0; jj<tile_width; jj++){
            std::copy( data_image, data_image + tile_height, q ) ;
            data_image += nrow ;

            q += out_height ;
          }
        }

        rowpos += tile_height ;

      }

      colpos += tile_width ;
      p += out_height * tile_width ;

    }
    std::fill( p, p+size*out_height, value ) ;

  } ;

  tbb::parallel_invoke(
     [&]{ fill_grid(0) ; },
     [&]{ fill_grid(1) ; },
     [&]{ fill_grid(2) ; }
  ) ;

  return out ;
}

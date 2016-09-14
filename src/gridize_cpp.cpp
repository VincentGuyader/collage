#include <tipixel.h>

// res <- gridize( file = sample_image(), width = 10, height = 10, col = "white")
// plotraster( gridize( file = sample_image(), width = 10, height = 10, col = "white") )
// [[Rcpp::export]]
NumericVector gridize_cpp( NumericVector img, int width, int height, int size, NumericVector rgb){
  IntegerVector dim = img.attr("dim") ;
  int nrow = dim[0] ;
  int ncol = dim[1] ;

  IntegerVector a_steps = steps(nrow, height) ;
  IntegerVector b_steps = steps(ncol, width) ;

  int out_width = ncol + size * ( width + 1 );
  int out_height = nrow + size * (height + 1) ;

  // NumericVector out = no_init( 3 * out_width * out_height) ;
  NumericVector out( 3 * out_width * out_height) ;
  out.attr("dim") = IntegerVector::create( out_height, out_width, 3 ) ;

  auto fill_grid = [&](int channel){
    double value = rgb[channel] ;
    double* p = out.begin() + channel * out_height * out_width ;

    for( int j=0; j<width; j++){
      int b_from = b_steps[j], b_to = b_steps[j+1]  ;
      std::fill(p, p + size * out_height, value ) ;

      double* q = p + out_height*size ;
      int ncolumns = b_to - b_from ;
      for( int k=0; k<ncolumns; k++){
        for( int i=0; i<height; i++){
          std::fill( q, q+size, value ) ;

          q+= size + a_steps[i+1] - a_steps[i] ;
        }
      }

      p += out_height * ( size + b_to - b_from) ;

    }

  } ;

  tbb::parallel_invoke(
     [&]{ fill_grid(0) ; },
     [&]{ fill_grid(1) ; },
     [&]{ fill_grid(2) ; }
  ) ;

  return out ;
}

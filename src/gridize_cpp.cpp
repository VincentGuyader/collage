#include <tipixel.h>

// [[Rcpp::export]]
RawVector add_grid_cpp( RawVector img, int size, RawVector grid_color){
  IntegerVector dim = img.attr("dim") ;
  int ncol = dim[1], nrow = dim[2] ;

  IntegerVector row_steps = get_steps( nrow, size ) ;
  int nr = row_steps.size() - 1 ;

  IntegerVector col_steps = get_steps( ncol, size ) ;
  int nc = col_steps.size() - 1 ;

  int height = nr + nrow ;
  int width = nc + ncol ;
  int n = 4 * width * height ;

  RawVector out(n) ;

  auto add_grid_pixel = [&](Rbyte* q){
    std::copy( grid_color.begin(), grid_color.end(), q ) ;
    q[3] = OPAQUE ;
    return q + 4 ;
  } ;

  for( int i=0; i<nr; i++){

    int row_start = row_steps[i] ;
    int row_end   = row_steps[i+1] ;

    int offset = i * ( size + 1 ) * width * 4 ;
    Rbyte* q = out.begin() + offset ;

    // horizontal fill
    for( int j=0; j<width; j++){
      q = add_grid_pixel(q) ;
    }

    for( int ii=row_start; ii<row_end; ii++){
      Rbyte* p = img.begin() + 4 * ii * ncol ;
      q = out.begin() + (1+i+ii)*4*width ;

      for( int j=0; j<nc; j++){
        int col_start = 4 * col_steps[j] ;
        int col_end   = 4 * col_steps[j+1] ;
        int cols      = col_end - col_start ;

        // vertical grid
        q = add_grid_pixel(q) ;

        // copy data from source image
        std::copy( p, p + cols, q ) ;
        q += cols ;
        p += cols ;
      }
    }

  }

  out.attr("dim") = IntegerVector::create( 4, width, height ) ;
  return out ;
}


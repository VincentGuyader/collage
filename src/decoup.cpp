#include <Rcpp.h>
#include <RcppParallel.h>
#include <tbb/parallel_invoke.h>

using namespace Rcpp ;
#include <math.h>

IntegerVector steps( int initial, int requested){
  double step = (initial - 1.0 ) / requested ;

  IntegerVector res(requested + 1) ;
  double value = 1.0 ;
  for( int i=0; i<requested+1; i++, value += step ){
    res[i] = nearbyint(value) - 1;
  }
  return res ;
}

double meanview( const NumericVector& img, int nrow, int ncol, int row_from, int row_to, int col_from, int col_to, int channel){
  // where to start in the array
  // - nrow*ncol*channel : jump to the right channel (r,g,b)
  // - col_from*nrow     : ... then to the right column
  // - row_from          : ... then to the right row
  int offset = nrow*ncol*channel + col_from*nrow + row_from;
  const double* start = img.begin() + offset ;

  int rows = row_to - row_from + 1;
  int cols = col_to - col_from + 1 ;

  double res = 0.0 ;
  for( int j=0; j<cols; j++, start += nrow ){
    res = std::accumulate(start, start+rows, res) ;
  }
  return res / (rows*cols) ;
}

//' @importFrom RcppParallel RcppParallelLibs
// [[Rcpp::export]]
DataFrame decoupsynth_cpp( NumericVector img, int lig, int col ){
  IntegerVector dim = img.attr("dim") ;
  int nrow = dim[0], ncol = dim[1] ;

  IntegerVector a_steps = steps(nrow, lig) ;
  IntegerVector b_steps = steps(ncol, col) ;
  int n = lig*col ;

  auto mean_channel = [&]( NumericVector& out, int channel ){
    double* p = out.begin() ;
    for(int j=0, k=0; j<col; j++){
      for(int i=0; i<lig; i++, k++ ){
        p[k]   = meanview(img, nrow, ncol, a_steps[i], a_steps[i+1], b_steps[j], b_steps[j+1], channel ) ;
      }
    }
  } ;
  NumericVector red = no_init(n), green = no_init(n), blue = no_init(n) ;

  tbb::parallel_invoke(
      [&]{ mean_channel(red, 0) ; },
      [&]{ mean_channel(green, 1) ; },
      [&]{ mean_channel(blue, 2) ; }
    ) ;
  DataFrame tab = DataFrame::create( _["R"] = red, _["G"] = green, _["B"] = blue, _["stringsAsFactors"] = false ) ;
  tab.attr("class") = CharacterVector::create( "tbl_df", "tbl", "data.frame") ;
  return tab ;
}

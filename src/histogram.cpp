#include <Rcpp.h>
using namespace Rcpp ;

// [[Rcpp::export]]
DataFrame magick_image_histogram( RawVector img ){

  IntegerVector red(256), green(256), blue(256) ;
  IntegerVector luminosity(256) ;
  IntegerVector dim = img.attr("dim") ;
  int width = dim[1] ;
  int height = dim[2] ;

  Rbyte* p = img.begin() ;
  for( int i=0; i<height; i++){
    for(int j=0; j<width; j++, p+=4){
      if( p[3] ){ // not counting the transparent pixels
        red[ p[0] ]++ ;
        green[ p[1] ]++ ;
        blue[ p[2] ]++ ;
      }
    }
  }
  IntegerVector idx = seq(0,255) ;

  return DataFrame::create(
    _["intensity"] = idx,
    _["red"] = red,
    _["green"] = green,
    _["blue"] = blue
  ) ;
}

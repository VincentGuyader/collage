#include <Rcpp.h>
#include <RcppParallel.h>
#include <math.h>
using namespace Rcpp ;

const Rbyte WHITE  = 255 ;
const Rbyte BLACK  = 0 ;
const Rbyte OPAQUE = 255 ;

IntegerVector get_steps( int n, int size) ;

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



// [[Rcpp::export]]
NumericVector collage_old( List tiles, int width, int height, IntegerVector best_tiles, int tile_dim){
  int pixels_per_channel = width * height * (tile_dim * tile_dim) ;
  NumericVector out = no_init( 3*pixels_per_channel) ;
  int ntiles = tiles.size() ;
  std::vector<NumericVector> tiles_vector( tiles.begin(), tiles.end() ) ;

  auto get_tiles_channels = [&,ntiles](int channel){
    std::vector<double*> res(ntiles) ;
    for(int i=0; i<ntiles; i++){
      res[i] = tiles_vector[i].begin() + channel * (tile_dim*tile_dim) ;
    }
    return res ;
  } ;

  auto copy_tile = [height,tile_dim]( double* dest, double* data ){
    for( int j=0; j<tile_dim; j++, dest+= tile_dim*height , data += tile_dim){
      std::copy( data, data + tile_dim, dest ) ;
    }
  } ;

  auto fill_channel = [&, ntiles]( int channel ){
    // where to write in the right channel (rgb)
    double* out_channel = out.begin() + channel * pixels_per_channel ;

    // pointers to start of the channel for each tile
    std::vector<double*> tiles_channel = get_tiles_channels(channel) ;

    tbb::parallel_for( 0, width, [&](int j){
      int k = j*height ;
      for(int i=0; i<height; i++, k++){
        // get data for the right tile in the right channel ;
        double* data = tiles_channel[ best_tiles[k] ] ;

        // where to copy the data
        double* dest = out_channel + j*height*tile_dim*tile_dim + i * tile_dim ;

        copy_tile(dest, data) ;
      }
    });

  } ;
  tbb::parallel_invoke(
    [&]{ fill_channel(0) ; },
    [&]{ fill_channel(1) ; },
    [&]{ fill_channel(2) ; }
  ) ;

  out.attr("dim") = IntegerVector::create( tile_dim*height, tile_dim*width, 3 ) ;
  return out ;
}

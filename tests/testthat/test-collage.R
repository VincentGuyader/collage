test_that("collage returns a magick image with the expected dimensions", {
  img <- test_image(width = 40, height = 30)
  size <- 10
  res <- collage(img, tiles = samples, size = size)

  expect_s3_class(res, "magick-image")

  tile_px <- ncol(samples$tile[[1]])
  info <- magick::image_info(res)
  expect_equal(info$width, n_chunks(40, size) * tile_px)
  expect_equal(info$height, n_chunks(30, size) * tile_px)
})

test_that("collage accepts a raw bitmap directly, not only a magick image", {
  img <- test_image(width = 40, height = 30)
  bm <- as_bitmap(img)

  from_image <- magick::image_info(collage(img, tiles = samples, size = 10))
  from_bitmap <- magick::image_info(collage(bm, tiles = samples, size = 10))

  expect_equal(from_bitmap$width, from_image$width)
  expect_equal(from_bitmap$height, from_image$height)
})

test_that("smaller tile size produces a larger mosaic", {
  img <- test_image(width = 60, height = 60)

  big_blocks <- magick::image_info(collage(img, tiles = samples, size = 20))
  small_blocks <- magick::image_info(collage(img, tiles = samples, size = 10))

  expect_gt(small_blocks$width, big_blocks$width)
})

test_that("the tile pixel size drives the output scale", {
  img <- test_image(width = 50, height = 50)
  size <- 25

  # samples tiles are 25x25, kittens tiles are 50x50
  small_tiles <- magick::image_info(collage(img, tiles = samples, size = size))
  large_tiles <- magick::image_info(collage(img, tiles = kittens, size = size))

  expect_equal(large_tiles$width, small_tiles$width * 2)
})

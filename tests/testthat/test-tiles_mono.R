test_that("tiles_mono builds one monochromatic tile per colour", {
  out <- tiles_mono(c("red", "white", "black"), size = 8)

  expect_s3_class(out, "tbl_df")
  expect_equal(nrow(out), 3)
  expect_true(all(c("red", "green", "blue", "alpha", "tile") %in% names(out)))
  expect_type(out$tile, "list")
})

test_that("the colour channels match the requested colours", {
  out <- tiles_mono(c("red", "white", "black"), size = 8)

  # red == #FF0000
  expect_equal(as.integer(out$red[1]), 255)
  expect_equal(as.integer(out$green[1]), 0)
  expect_equal(as.integer(out$blue[1]), 0)

  # black == #000000
  expect_equal(as.integer(out$red[3]), 0)
})

test_that("a mono tile is a uniform size x size x 4 bitmap", {
  out <- tiles_mono("red", size = 8)
  tile <- out$tile[[1]]

  expect_equal(dim(tile), c(4L, 8L, 8L))
  # every red-channel cell is 0xff for a fully red tile
  expect_true(all(as.integer(tile[1, , ]) == 255))
  # alpha channel fully opaque
  expect_true(all(as.integer(tile[4, , ]) == 255))
})

test_that("a mono tiles base can drive a collage", {
  img <- test_image(width = 30, height = 30, color = "red")
  rtiles <- tiles_mono(grDevices::colors(), size = 10)

  res <- collage(img, tiles = rtiles, size = 10)
  expect_s3_class(res, "magick-image")
})

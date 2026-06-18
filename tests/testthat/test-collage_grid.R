test_that("collage_grid adds one grid line per chunk to the image size", {
  img <- test_image(width = 40, height = 30)
  size <- 10
  res <- collage_grid(img, size = size, grid_col = "white")

  expect_s3_class(res, "magick-image")

  info <- magick::image_info(res)
  expect_equal(info$width, 40 + n_chunks(40, size))
  expect_equal(info$height, 30 + n_chunks(30, size))
})

test_that("collage_grid accepts named colours", {
  img <- test_image(width = 20, height = 20)
  expect_s3_class(collage_grid(img, size = 5, grid_col = "red"), "magick-image")
})

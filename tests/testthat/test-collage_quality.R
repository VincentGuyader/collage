test_that("collage_quality returns a grayscale-sized mask image", {
  img <- test_image(width = 40, height = 30)
  size <- 10
  res <- collage_quality(img, tiles = samples, size = size)

  expect_s3_class(res, "magick-image")

  info <- magick::image_info(res)
  expect_equal(info$width, n_chunks(40, size) * size)
  expect_equal(info$height, n_chunks(30, size) * size)
})

test_that("collage_quality honours an explicit max_distance", {
  img <- test_image(width = 40, height = 30)

  res <- collage_quality(
    img,
    tiles = samples,
    size = 10,
    min_distance = 0,
    max_distance = 0.5
  )

  expect_s3_class(res, "magick-image")
})

test_that("base_mask clamps distances below min to white and above max to black", {
  # distances straddling the [min, max] window exercise all three grayscale
  # branches: below min (white, 0xff), inside the window, above max (black, 0)
  size <- 4
  width <- 3
  height <- 1
  mask <- base_mask(
    distances = c(0.1, 0.3, 0.9),
    width = width,
    height = height,
    size = size,
    min_distance = 0.2,
    max_distance = 0.5
  )

  expect_equal(dim(mask), c(4L, width * size, height * size))

  # first block (d = 0.1 < min) is white, last block (d = 0.9 > max) is black
  first_block_value <- as.integer(mask[1, 1, 1])
  last_block_value <- as.integer(mask[1, width * size, 1])
  expect_equal(first_block_value, 255)
  expect_equal(last_block_value, 0)
})

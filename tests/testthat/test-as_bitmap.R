test_that("as_bitmap converts a magick image to an rgba bitmap array", {
  img <- test_image(width = 12, height = 8)
  bm <- as_bitmap(img)

  expect_true(inherits(bm, "bitmap"))
  # magick image_data layout is c(channels, width, height)
  expect_identical(dim(bm), c(4L, 12L, 8L))
  expect_type(bm, "raw")
})

test_that("as_bitmap leaves an existing bitmap untouched", {
  img <- test_image(width = 12, height = 8)
  bm <- as_bitmap(img)

  expect_identical(as_bitmap(bm), bm)
})

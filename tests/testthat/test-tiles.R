test_that("tiles builds a tibble with one row per file and the expected columns", {
  files <- base_files(n = 3)
  out <- tiles(files, size = 10)

  expect_s3_class(out, "tbl_df")
  expect_equal(nrow(out), 3)
  expect_named(out, c("red", "green", "blue", "alpha", "tile"))

  expect_type(out$red, "raw")
  expect_type(out$green, "raw")
  expect_type(out$blue, "raw")
  expect_type(out$alpha, "raw")
  expect_type(out$tile, "list")
})

test_that("tiles produces square bitmaps of the requested size", {
  out <- tiles(base_files(n = 2), size = 12)

  expect_equal(dim(out$tile[[1]]), c(4L, 12L, 12L))
})

test_that("image_center_crop is applied so tiles are square even from rectangles", {
  # all bundled base images are 340px wide rectangles; the crop must yield a
  # square tile regardless of the original aspect ratio
  out <- tiles(base_files(n = 1), size = 20)
  expect_equal(dim(out$tile[[1]])[2], dim(out$tile[[1]])[3])
})

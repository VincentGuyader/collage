test_that("image_histogram_data returns a 256-row tone table", {
  img <- test_image(width = 10, height = 8, color = "red")
  h <- image_histogram_data(img)

  expect_s3_class(h, "tbl_df")
  expect_equal(nrow(h), 256)
  expect_named(h, c("tone", "red", "green", "blue"))
  expect_equal(h$tone, 0:255)
})

test_that("pixel counts add up to the opaque pixel count", {
  img <- test_image(width = 10, height = 8, color = "red")
  h <- image_histogram_data(img)

  expect_equal(sum(h$red), 10 * 8)
  expect_equal(sum(h$green), 10 * 8)
  expect_equal(sum(h$blue), 10 * 8)
})

test_that("a solid red image peaks at 255 red and 0 green/blue", {
  img <- test_image(width = 10, height = 8, color = "red")
  h <- image_histogram_data(img)

  expect_equal(h$red[h$tone == 255], 80)
  expect_equal(h$green[h$tone == 0], 80)
  expect_equal(h$blue[h$tone == 0], 80)
})

test_that("brightness and rgb histograms return buildable ggplots", {
  img <- test_image(width = 10, height = 8, color = "red")

  gb <- image_histogram_brightness(img)
  gr <- image_histogram_rgb(img)

  expect_s3_class(gb, "ggplot")
  expect_s3_class(gr, "ggplot")

  # building exercises the aes / geom layers without rendering a device
  expect_no_error(ggplot2::ggplot_build(gb))
  expect_no_error(ggplot2::ggplot_build(gr))
})

test_that("custom luma coefficients are accepted", {
  img <- test_image(width = 10, height = 8, color = "red")
  g <- image_histogram_brightness(img, coefficients = c(0.2, 0.7, 0.1))
  expect_s3_class(g, "ggplot")
})

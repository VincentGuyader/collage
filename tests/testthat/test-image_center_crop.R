test_that("image_center_crop makes a square from a landscape image", {
  img <- test_image(width = 100, height = 60)
  cropped <- image_center_crop(img)

  info <- magick::image_info(cropped)
  expect_equal(info$width, 60)
  expect_equal(info$height, 60)
})

test_that("image_center_crop makes a square from a portrait image", {
  img <- test_image(width = 40, height = 90)
  cropped <- image_center_crop(img)

  info <- magick::image_info(cropped)
  expect_equal(info$width, 40)
  expect_equal(info$height, 40)
})

test_that("the crop geometry centers the square on the long axis", {
  landscape <- image_center_crop_geometry(test_image(width = 100, height = 60))
  expect_equal(landscape, "60x60+20")

  portrait <- image_center_crop_geometry(test_image(width = 40, height = 90))
  expect_equal(portrait, "40x40+0+25")
})

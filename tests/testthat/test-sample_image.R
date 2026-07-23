test_that("sample_image returns an existing jpeg path for a given index", {
  path <- sample_image(1)

  expect_type(path, "character")
  expect_length(path, 1)
  expect_true(file.exists(path))
  expect_match(path, "[.]jpe?g$")
})

test_that("sample_image picks a bundled image at random when index is missing", {
  set.seed(1)
  path <- sample_image()

  expect_true(file.exists(path))
  expect_match(path, "[.]jpe?g$")
})

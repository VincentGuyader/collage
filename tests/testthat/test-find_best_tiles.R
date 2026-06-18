test_that("find_best_tiles reports ceil(n / size) chunks per axis", {
  img <- as_bitmap(test_image(width = 40, height = 30))
  size <- 10

  best <- find_best_tiles(img, size, samples)

  expect_equal(attr(best, "width"), n_chunks(40, size))
  expect_equal(attr(best, "height"), n_chunks(30, size))
})

test_that("the selected tile indices are valid 0-based positions", {
  img <- as_bitmap(test_image(width = 40, height = 30))
  best <- find_best_tiles(img, 10, samples)

  expect_true(all(best >= 0))
  expect_true(all(best < nrow(samples)))
})

test_that("distances are normalised between 0 and 1", {
  img <- as_bitmap(test_image(width = 40, height = 30))
  best <- find_best_tiles(img, 10, samples)
  distances <- attr(best, "distances")

  expect_true(all(distances >= 0))
  expect_true(all(distances <= 1))
  expect_length(distances, attr(best, "width") * attr(best, "height"))
})

test_that("lines_cut returns floor(height / n) with a lost attribute", {
  img <- test_image(width = 100, height = 80)
  out <- lines_cut(img, n = 10)

  expect_equal(as.integer(out), 8L) # floor(80 / 10)
  lost <- attr(out, "lost")
  expect_named(lost, c("bottom", "right"))
  expect_equal(unname(lost["bottom"]), 80 %% 8)
  expect_equal(unname(lost["right"]), 100 %% 8)
})

test_that("columns_cut returns floor(width / n)", {
  img <- test_image(width = 100, height = 80)
  out <- columns_cut(img, n = 10)

  expect_equal(as.integer(out), 10L) # floor(100 / 10)
})

test_that("a non-divisible cut leaves lost pixels", {
  img <- test_image(width = 100, height = 75)
  out <- lines_cut(img, n = 10)

  expect_equal(as.integer(out), 7L) # floor(75 / 10)
  expect_gt(unname(attr(out, "lost")["bottom"]), 0)
})

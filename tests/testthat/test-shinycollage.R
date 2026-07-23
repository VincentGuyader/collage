test_that("shinycollage launches the bundled app directory", {
  skip_if_not_installed("shiny")

  captured <- NULL
  local_mocked_bindings(
    runApp = function(appDir, display.mode, ...) {
      captured <<- list(appDir = appDir, display.mode = display.mode)
      invisible(NULL)
    },
    .package = "shiny"
  )

  shinycollage()

  expect_true(dir.exists(captured$appDir))
  expect_true(file.exists(file.path(captured$appDir, "server.R")))
  expect_equal(captured$display.mode, "normal")
})

test_that("shinycollage errors when the bundled app cannot be found", {
  skip_if_not_installed("mockery")

  mockery::stub(shinycollage, "system.file", "")
  expect_error(shinycollage(), "Could not find")
})

test_that("shinycollage forwards the display.mode argument", {
  skip_if_not_installed("shiny")

  captured <- NULL
  local_mocked_bindings(
    runApp = function(appDir, display.mode, ...) {
      captured <<- display.mode
      invisible(NULL)
    },
    .package = "shiny"
  )

  shinycollage(display.mode = "showcase")
  expect_equal(captured, "showcase")
})

# Shared fixtures for the test suite.
#
# Everything here is deterministic and offline: small solid-colour images
# built with {magick}, and the image files bundled in inst/base. This keeps
# the tests fast and reproducible on CI.

# A solid-colour image of known dimensions.
test_image <- function(width = 40, height = 30, color = "white") {
  magick::image_blank(width = width, height = height, color = color)
}

# A handful of the bundled base images, as file paths.
base_files <- function(n = 3) {
  path <- system.file("base", package = "collage")
  files <- list.files(path, pattern = "[.]jpe?g$", full.names = TRUE)
  utils::head(files, n = n)
}

# Expected collage / quality / grid dimensions, mirroring the C++ get_steps()
# which uses ceil(n / size) chunks.
n_chunks <- function(n, size) {
  ceiling(n / size)
}

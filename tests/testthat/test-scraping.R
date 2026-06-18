# The scraping helpers hit photos-animaux.com. We never touch the network in
# tests: read_html and download.file are mocked, and the real xml2/rvest
# parsers run against a small fixed HTML fixture so the parsing logic is still
# exercised.

fake_page_html <- function() {
  xml2::read_html(paste0(
    "<html><body>",
    "<ul><li class=\"page\">Page 1 sur 3</li></ul>",
    "<div class=\"_image\"><img src=\"http://example.com/a.jpg\"/></div>",
    "<div class=\"_image\"><img src=\"http://example.com/b.jpg\"/></div>",
    "</body></html>"
  ))
}

test_that("npages parses the trailing page count", {
  local_mocked_bindings(read_html = function(...) {
    fake_page_html()
  })

  expect_equal(npages("bebe,chats"), 3)
})

test_that("scrap extracts the image src attributes", {
  local_mocked_bindings(read_html = function(...) {
    fake_page_html()
  })

  urls <- scrap(page = 1, what = "bebe,chats")
  expect_equal(urls, c("http://example.com/a.jpg", "http://example.com/b.jpg"))
})

test_that("scrap_animals flattens urls across the requested pages", {
  local_mocked_bindings(read_html = function(...) {
    fake_page_html()
  })

  urls <- scrap_animals(what = "bebe,chats", pages = 1:2)
  expect_length(urls, 4)
})

test_that("scrap_animals falls back to npages when pages is missing", {
  local_mocked_bindings(read_html = function(...) {
    fake_page_html()
  })

  urls <- scrap_animals(what = "bebe,chats")
  expect_length(urls, 3 * 2) # 3 pages x 2 images
})

test_that("tiles_animals downloads urls and builds a tiles tibble", {
  files <- base_files(n = 2)

  local_mocked_bindings(
    scrap_animals = function(what, pages) {
      files
    },
    download.file = function(url, destfile, ...) {
      file.copy(from = url, to = destfile)
    }
  )

  out <- tiles_animals(size = 10, what = "bebe,chats", pages = 1)

  expect_s3_class(out, "tbl_df")
  expect_equal(nrow(out), length(files))
  expect_equal(dim(out$tile[[1]]), c(4L, 10L, 10L))
})

#!/usr/bin/env Rscript

# Generate three collage mosaics from source images of increasing size
# (small / medium / large) to exercise the package end to end.
#
# For each example we:
#   - resize the bundled "tigrou" demo photo to a target width
#   - build a mosaic where every `size`x`size` block of the source is
#     replaced by the closest-matching kitten tile
#   - save the source and the resulting mosaic, and report timing + dims
#
# Run from the package root:  Rscript examples/build_examples.R

suppressMessages({
  library(collage)
  library(magick)
})

out_dir <- file.path("examples", "output")
if (!dir.exists(out_dir)) {
  dir.create(out_dir, recursive = TRUE)
}

tigrou <- image_read(system.file("tigrou", "tigrou.jpg", package = "collage"))

# Each example: a label, the source width to resize to, and the block size.
# A smaller block `size` means more (and finer) tiles, hence a bigger output
# and more work, so we keep it proportional to the source size.
examples <- list(
  list(label = "small",  width = 200,  size = 10),
  list(label = "medium", width = 640,  size = 16),
  list(label = "large",  width = 1500, size = 25)
)

summary_rows <- list()

for (ex in examples) {
  src <- image_scale(tigrou, geometry = as.character(ex$width))
  info_src <- image_info(src)

  tiles_x <- info_src$width  %/% ex$size
  tiles_y <- info_src$height %/% ex$size

  src_path <- file.path(out_dir, sprintf("%s_source.png", ex$label))
  image_write(src, src_path)

  t0 <- Sys.time()
  mosaic <- collage(src, tiles = kittens, size = ex$size)
  elapsed <- as.numeric(Sys.time() - t0, units = "secs")

  info_out <- image_info(mosaic)
  out_path <- file.path(out_dir, sprintf("%s_mosaic.png", ex$label))
  image_write(mosaic, out_path)

  summary_rows[[ex$label]] <- data.frame(
    example      = ex$label,
    source       = sprintf("%dx%d", info_src$width, info_src$height),
    block_size   = ex$size,
    tiles        = sprintf("%dx%d (%d)", tiles_x, tiles_y, tiles_x * tiles_y),
    mosaic       = sprintf("%dx%d", info_out$width, info_out$height),
    seconds      = round(elapsed, 2),
    stringsAsFactors = FALSE
  )

  message(sprintf(
    "[%s] source %dx%d -> %d tiles -> mosaic %dx%d in %.2fs",
    ex$label, info_src$width, info_src$height,
    tiles_x * tiles_y, info_out$width, info_out$height, elapsed
  ))
}

summary_df <- do.call(rbind, summary_rows)
rownames(summary_df) <- NULL
cat("\n=== Summary ===\n")
print(summary_df, row.names = FALSE)

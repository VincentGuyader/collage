#!/usr/bin/env Rscript

# Benchmark platform for {collage}.
#
# Measures, for several image sizes and tile bases:
#   - end-to-end collage() wall time and R-side memory,
#   - a per-stage breakdown of the collage() pipeline:
#       as_bitmap        (magick -> raw bitmap conversion)
#       find_best_tiles  (C++ block averaging + nearest-tile search)
#       collage_impl     (C++ mosaic assembly)
#       image_read       (raw bitmap -> magick object)
#
# It also records a golden master checksum of every mosaic so that an
# optimised version can be checked for byte-identical output:
#   Rscript dev/bench/bench_collage.R          # bench + write/refresh results
#   Rscript dev/bench/bench_collage.R --check  # compare checksums to golden file
#
# Results land in dev/bench/results/ (tracked), machine-tagged.

suppressMessages({
  library(collage)
  library(magick)
})

args <- commandArgs(trailingOnly = TRUE)
check_only <- "--check" %in% args

here <- normalizePath(file.path(dirname(sub("--file=", "", grep("--file=", commandArgs(), value = TRUE)))))
res_dir <- file.path(here, "results")
if (!dir.exists(res_dir)) {
  dir.create(res_dir, recursive = TRUE)
}
golden_file <- file.path(res_dir, "golden_master.csv")

tigrou <- image_read(system.file("tigrou", "tigrou.jpg", package = "collage"))

scenarios <- list(
  list(label = "small_samples",   width = 200,  size = 10, base = "samples"),
  list(label = "medium_samples",  width = 640,  size = 16, base = "samples"),
  list(label = "medium_kittens",  width = 640,  size = 16, base = "kittens"),
  list(label = "large_kittens",   width = 1500, size = 25, base = "kittens"),
  # size 7 with 50px tiles gives a 10750x10100 mosaic (~414 MB rgba), the
  # largest that fits in ImageMagick default cache limits on this machine ;
  # size 5 (~843 MB) needs MAGICK_MEMORY_LIMIT and friends raised, see README
  list(label = "stress_kittens",  width = 1500, size = 7,  base = "kittens"),
  list(label = "stress_emojis",   width = 1500, size = 8,  base = "emojis")
)

get_base <- function(name) {
  get(name, envir = asNamespace("collage"))
}

# per-stage timing of one collage() call, replicated `reps` times
stage_times <- function(img, tiles, size, reps = 3) {
  one <- function() {
    t <- numeric(4)
    t0 <- proc.time()[["elapsed"]]
    bitmap <- magick::image_data(img, channels = "rgba")
    t[1] <- proc.time()[["elapsed"]] - t0

    t0 <- proc.time()[["elapsed"]]
    best <- collage:::find_best_tiles(bitmap, size, tiles)
    t[2] <- proc.time()[["elapsed"]] - t0

    tile_size <- ncol(tiles$tile[[1]])
    t0 <- proc.time()[["elapsed"]]
    out <- collage:::collage_impl(
      tiles$tile,
      attr(best, "width"),
      attr(best, "height"),
      best,
      tile_size
    )
    t[3] <- proc.time()[["elapsed"]] - t0

    t0 <- proc.time()[["elapsed"]]
    res <- magick::image_read(out)
    t[4] <- proc.time()[["elapsed"]] - t0
    rm(res, out, bitmap)
    gc(verbose = FALSE)
    t
  }
  m <- vapply(seq_len(reps), function(i) {
    one()
  }, numeric(4))
  stats::setNames(apply(m, 1, median), c("as_bitmap", "find_best_tiles", "collage_impl", "image_read"))
}

mosaic_checksum <- function(img, tiles, size) {
  bitmap <- magick::image_data(img, channels = "rgba")
  best <- collage:::find_best_tiles(bitmap, size, tiles)
  tile_size <- ncol(tiles$tile[[1]])
  out <- collage:::collage_impl(
    tiles$tile,
    attr(best, "width"),
    attr(best, "height"),
    best,
    tile_size
  )
  # digest of the raw mosaic bitmap, before magick re-encoding
  paste0(
    "md5:",
    tools::md5sum(local({
      f <- tempfile()
      writeBin(as.raw(out), con = f)
      f
    }))[[1]]
  )
}

rows <- list()
golden_rows <- list()

for (sc in scenarios) {
  src <- image_scale(tigrou, geometry = as.character(sc$width))
  tiles <- get_base(sc$base)
  info <- image_info(src)
  n_blocks <- (info$width %/% sc$size) * (info$height %/% sc$size)

  checksum <- mosaic_checksum(img = src, tiles = tiles, size = sc$size)
  golden_rows[[sc$label]] <- data.frame(
    scenario = sc$label,
    checksum = checksum,
    stringsAsFactors = FALSE
  )

  if (!check_only) {
    # median of 3 end-to-end runs ; gc between runs so that the previous
    # mosaic is released from the magick pixel cache before the next one
    totals <- vapply(1:3, function(i) {
      t <- system.time(m <- collage(src, tiles = tiles, size = sc$size))[["elapsed"]]
      rm(m)
      gc(verbose = FALSE)
      t
    }, numeric(1))
    total <- stats::median(totals)
    st <- stage_times(img = src, tiles = tiles, size = sc$size)

    rows[[sc$label]] <- data.frame(
      scenario = sc$label,
      source = sprintf("%dx%d", info$width, info$height),
      block_size = sc$size,
      n_blocks = n_blocks,
      n_tiles = nrow(tiles),
      median_s = total,
      t_as_bitmap = st[["as_bitmap"]],
      t_find_best_tiles = st[["find_best_tiles"]],
      t_collage_impl = st[["collage_impl"]],
      t_image_read = st[["image_read"]],
      stringsAsFactors = FALSE
    )
    message(sprintf(
      "%-15s %9s size=%2d blocks=%6d tiles=%4d  total=%6.3fs  [bitmap %5.3f | find %5.3f | impl %5.3f | read %5.3f]",
      sc$label, rows[[sc$label]]$source, sc$size, n_blocks, nrow(tiles),
      total, st[["as_bitmap"]], st[["find_best_tiles"]], st[["collage_impl"]], st[["image_read"]]
    ))
  }
}

golden <- do.call(rbind, golden_rows)

if (check_only) {
  if (!file.exists(golden_file)) {
    stop("No golden master file at ", golden_file, " ; run without --check first.")
  }
  ref <- utils::read.csv(golden_file, stringsAsFactors = FALSE)
  cmp <- merge(ref, golden, by = "scenario", suffixes = c("_ref", "_new"))
  same <- cmp$checksum_ref == cmp$checksum_new
  for (i in seq_len(nrow(cmp))) {
    message(sprintf(
      "%-15s %s", cmp$scenario[i],
      if (same[i]) {
        "IDENTICAL"
      } else {
        sprintf("DIFFERS (ref %s vs new %s)", cmp$checksum_ref[i], cmp$checksum_new[i])
      }
    ))
  }
  if (all(same)) {
    message("golden master: all ", nrow(cmp), " scenarios byte-identical")
  } else {
    stop("golden master mismatch on: ", paste(cmp$scenario[!same], collapse = ", "))
  }
} else {
  results <- do.call(rbind, rows)
  stamp <- format(Sys.time(), "%Y%m%d-%H%M%S")
  out_file <- file.path(res_dir, sprintf("bench_%s_%s.csv", Sys.info()[["nodename"]], stamp))
  utils::write.csv(results, file = out_file, row.names = FALSE)
  utils::write.csv(golden, file = golden_file, row.names = FALSE)
  message("results written to ", out_file)
  message("golden master written to ", golden_file)
}

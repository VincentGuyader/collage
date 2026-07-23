# Benchmark platform for {collage}

## Usage

From the package root, with the version to measure installed:

```sh
# measure + refresh golden master
Rscript dev/bench/bench_collage.R

# after changing the C++ code: check the mosaics are byte-identical
# to the recorded golden master, then re-measure
R CMD INSTALL --preclean .
Rscript dev/bench/bench_collage.R --check
Rscript dev/bench/bench_collage.R
```

Each run writes a machine-and-time-stamped CSV in `dev/bench/results/`
with, per scenario: end-to-end median wall time (3 runs) and a per-stage
breakdown of the `collage()` pipeline (`image_data`, `find_best_tiles`,
`collage_impl`, `image_read`).

The golden master (`results/golden_master.csv`) stores an md5 of the raw
mosaic bitmap of every scenario, computed before magick re-encoding, so
`--check` detects any single-byte drift in the C++ output.

## What the numbers say (8-core Linux VPS, R 4.5.1, ImageMagick 7.1.2)

- The C++ stages are fast: on a 1500px source, `find_best_tiles` and
  `collage_impl` together stay under 0.25 s in every scenario.
- End-to-end time is dominated by the magick conversions, mainly
  `image_read()` of the final mosaic bitmap (up to ~85 % of the total on
  large outputs). This cost is inside {magick}/ImageMagick, not in
  {collage} code.

## Resource limits to know about

- Output size grows as `(tile_size / size)^2` relative to the source:
  with 50px tiles and `size = 5`, a 1500px photo yields a 15000x14100
  mosaic, ~840 MB of rgba pixels.
- ImageMagick refuses to build such an image under its default cache
  policy (`cache resources exhausted`). Measured boundary on this
  machine: a ~414 MB mosaic passes, ~840 MB fails. To go beyond, raise
  the limits before starting R:

  ```sh
  MAGICK_MEMORY_LIMIT=4GiB MAGICK_MAP_LIMIT=4GiB MAGICK_AREA_LIMIT=1GP \
  MAGICK_DISK_LIMIT=8GiB MAGICK_WIDTH_LIMIT=100KP MAGICK_HEIGHT_LIMIT=100KP \
  Rscript ...
  ```

  Verified: with these variables the 840 MB mosaic builds in ~3.5 s with
  a ~2.6 GB peak RSS.
- The parallel C++ stages use every core by default. To cap CPU usage:
  `RcppParallel::setThreadOptions(numThreads = 2)`.

test_that("input validation works", {
  d <- c3d_read(c3d_example())
  d_wide <- c3d_data(d)
  d_long <- c3d_data(d, format = "long")
  d_longest <- c3d_data(d, format = "longest")

  expect_error(c3d_data(d, format = "short"), regexp = "'format' argument")
  expect_error(c3d_data("d"), regexp = "'x' needs to be")
  expect_error(c3d_convert(d, format = "long"), regexp = "'data' needs to be")
  expect_error(c3d_data(d_long, format = "short"), regexp = "'x' needs to be")
  expect_error(
    c3d_data(d_longest, format = "short"),
    regexp = "'x' needs to be"
  )

  # for internal functions
  expect_error(c3d_wide_to_long(d_long), regexp = "in 'wide' format.")
  expect_error(c3d_long_to_longest(d_wide), regexp = "in 'long' format.")
  expect_error(c3d_longest_to_long(d_long), regexp = "in 'longest' format.")
  expect_error(c3d_long_to_wide(d_wide), regexp = "in 'long' format.")
})

test_that("wide data retrieval works", {
  d <- c3d_read(c3d_example())
  d_wide <- c3d_data(d)

  # dimensions
  expect_equal(dim(d_wide), c(d$header$nframes, d$header$npoints * 3))
  # data
  expect_equal(d_wide[2, 3], d$data[[2]][[1]][[3]])
  # header labels
  expect_equal(
    colnames(d_wide)[[1]],
    paste0(d$parameters$POINT$LABELS[[1]], "_x")
  )
})

test_that("long data retrieval works", {
  d <- c3d_read(c3d_example())
  d_long <- c3d_data(d, format = "long")

  # dimensions
  expect_equal(dim(d_long), c(d$header$nframes * 3, d$header$npoints + 2))
  # data
  expect_equal(d_long[3, 3], d$data[[1]][[1]][[3]])
  # header
  expect_equal(colnames(d_long)[-(1:2)], d$parameters$POINT$LABELS)
})

test_that("longest data retrieval works", {
  d <- c3d_read(c3d_example())
  d_longest <- c3d_data(d, format = "longest")

  # dimensions
  expect_equal(nrow(d_longest), d$header$nframes * d$header$npoints * 3)
  # data
  expect_equal(d_longest$value[4], d$data[[1]][[2]][[1]])
})

test_that("sequential conversion leads to same results", {
  d <- c3d_read(c3d_example())
  d_wide <- c3d_data(d)
  d_longest <- c3d_data(d, format = "longest")

  expect_identical(c3d_convert(d_wide, "longest"), d_longest)
  expect_identical(
    c3d_convert(c3d_convert(d_wide, "long"), "longest"),
    d_longest
  )
  expect_identical(
    c3d_convert(c3d_convert(c3d_convert(d_wide, "longest"), "long"), "wide"),
    d_wide
  )
})

test_that("correct attributes and classes are exported", {
  d <- c3d_read(c3d_example())
  d_wide <- c3d_data(d)
  d_long <- c3d_data(d, format = "long")
  d_longest <- c3d_data(d, format = "longest")

  expect_s3_class(d_wide, c("c3d_data_wide", "c3d_data", "data.frame"))
  expect_s3_class(d_long, c("c3d_data_long", "c3d_data", "data.frame"))
  expect_s3_class(d_longest, c("c3d_data_longest", "c3d_data", "data.frame"))
})

test_that("reverse conversion works", {
  d <- c3d_read(c3d_example())
  d_wide <- c3d_data(d)
  d_long <- c3d_data(d, format = "long")

  expect_identical(c3d_longest_to_long(c3d_long_to_longest(d_long)), d_long)
  expect_identical(c3d_long_to_wide(c3d_wide_to_long(d_wide)), d_wide)
})

test_that("full backconversion has success", {
  d <- c3d_read(c3d_example())
  d_wide <- c3d_data(d)

  expect_identical(c3d_convert(c3d_convert(d_wide, "longest"), "wide"), d_wide)
})

test_that("conversion to same format works but gives message", {
  d <- c3d_read(c3d_example())
  d_wide <- c3d_data(d)
  d_long <- c3d_data(d, format = "long")
  d_longest <- c3d_data(d, format = "longest")

  suppressMessages(
    expect_identical(c3d_convert(d_wide, "wide"), d_wide)
  )
  suppressMessages(
    expect_identical(c3d_convert(d_long, "long"), d_long)
  )
  suppressMessages(
    expect_identical(c3d_convert(d_longest, "longest"), d_longest)
  )
  expect_message(
    c3d_convert(d_wide, "wide"),
    regexp = "already in 'wide' format"
  )
  expect_message(
    c3d_convert(d_long, "long"),
    regexp = "already in 'long' format"
  )
  expect_message(
    c3d_convert(d_longest, "longest"),
    regexp = "already in 'longest' format"
  )
})

test_that("analog data retrieval works", {
  d <- c3d_read(c3d_example())
  a <- c3d_analog(d)

  # dimensions
  expect_equal(
    dim(a),
    c(d$header$nframes * d$header$analogperframe, d$header$nanalogs)
  )
  # data
  expect_equal(a[2, 1], d$analog[[1]][2])
})

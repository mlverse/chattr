test_that("Saving defaults work", {
  ch_defaults(type = "console", force = TRUE)
  defaults_file <- tempfile()
  ch_defaults_save(
    path = defaults_file
  )
  expect_snapshot(readLines(defaults_file))
})

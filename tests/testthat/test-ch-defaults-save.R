test_that("Saving defaults work", {
  Sys.unsetenv("CHATTR_TYPE")
  expect_snapshot(chattr_use("gpt35"))
  defaults_file <- tempfile()
  expect_silent(
    chattr_defaults_save(
      type = "console",
      path = defaults_file,
      overwrite = TRUE
    )
  )
  expect_snapshot(readLines(defaults_file))
})

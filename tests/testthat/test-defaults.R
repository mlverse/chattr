test_that("Basic default tests", {
  Sys.setenv("chattr_TYPE" = "console")
  expect_snapshot(ch_defaults())
})

test_that("Basic default tests", {
  expect_snapshot(chattr_use("llamagpt"))
  Sys.setenv("CHATTR_TYPE" = "console")
  expect_snapshot(ch_defaults())
  Sys.unsetenv("CHATTR_TYPE")
})
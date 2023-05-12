test_that("Basic default tests", {
  Sys.setenv("TIDYCHAT_TYPE" = "console")
  expect_snapshot(tc_defaults())
})

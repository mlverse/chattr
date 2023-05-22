test_that("Basic default tests", {
  capture.output(ch_use_openai_gpt35())
  Sys.setenv("CHATTR_TYPE" = "console")
  expect_snapshot(ch_defaults())
})

test_that("Basic chattr() tests", {
  Sys.setenv("chattr_TYPE" = "console")
  expect_snapshot(chattr("test", preview = TRUE))
  expect_snapshot(chattr("test", preview = TRUE, prompt_build = FALSE))
  expect_snapshot(chattr("test", preview = TRUE, stream = FALSE))
  expect_snapshot(chattr(preview = TRUE))
  ch_debug_set_true()
  expect_snapshot(chattr("test", stream = FALSE))
})

test_that("Using DaVinci", {
  Sys.setenv("chattr_TYPE" = "console")
  ch_debug_set_false()
  expect_snapshot(ch_use_openai_davinci())
  expect_snapshot(chattr("test", preview = TRUE))
  ch_debug_set_true()
  expect_snapshot(chattr("test", stream = FALSE))
})

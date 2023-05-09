test_that("Basic tidychat() tests", {
  Sys.setenv("TIDYCHAT_TYPE" = "console")
  expect_snapshot(tidychat("test", preview = TRUE))
  expect_snapshot(tidychat("test", preview = TRUE, prompt_build = FALSE))
  expect_snapshot(tidychat("test", preview = TRUE, stream = FALSE))
  tc_debug_set_true()
  expect_snapshot(tidychat("test", stream = FALSE))
})

test_that("Using DaVinci", {
  Sys.setenv("TIDYCHAT_TYPE" = "console")
  tc_debug_set_false()
  expect_snapshot(tc_use_openai_davinci())
  expect_snapshot(tidychat("test", preview = TRUE))
  tc_debug_set_true()
  expect_snapshot(tidychat("test", stream = FALSE))
})

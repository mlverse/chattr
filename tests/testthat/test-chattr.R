test_that("Basic chattr() tests", {
  expect_snapshot(chattr_use("gpt35"))
  test_chattr_type_set("console")
  expect_snapshot(chattr("test", preview = TRUE))
  expect_snapshot(chattr("test", preview = TRUE, prompt_build = FALSE))
  expect_snapshot(chattr("test", preview = TRUE, stream = FALSE))
  expect_snapshot(chattr(preview = TRUE))
  ch_debug_set_true()
  expect_snapshot(chattr("test", stream = FALSE))
  ch_debug_set_false()
})

test_that("Using DaVinci", {
  test_chattr_type_set("console")
  ch_debug_set_false()
  expect_snapshot(ch_use_openai_davinci())
  expect_snapshot(chattr("test", preview = TRUE))
  ch_debug_set_true()
  expect_snapshot(chattr("test", stream = FALSE))
})

test_that("Data frames show up", {
  expect_snapshot(chattr(preview = TRUE))
})

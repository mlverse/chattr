skip()

test_that("Test function works for OpenAI", {
  ch_debug_set_true()
  expect_true(ch_debug_get())
  expect_snapshot(chattr_use("gpt35"))
  expect_snapshot(chattr_test())
  ch_debug_set_false()
  expect_false(ch_debug_get())
})

test_that("Test function works for LlamaGPT", {
  ch_debug_set_true()
  expect_true(ch_debug_get())
  expect_snapshot(chattr_use("llamagpt"))
  expect_snapshot(chattr_test())
  ch_debug_set_false()
  expect_false(ch_debug_get())
})

test_that("Test function works for Copilot", {
  ch_debug_set_true()
  expect_true(ch_debug_get())
  expect_snapshot(chattr_use("copilot"))
  expect_snapshot(chattr_test())
  ch_debug_set_false()
  expect_false(ch_debug_get())
})

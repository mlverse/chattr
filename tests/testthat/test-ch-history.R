skip()

test_that("History functions work", {
  expect_null(ch_history_set(NULL))
  expect_null(ch_history())
  expect_silent(ch_history_append("user", "assistant"))
  expect_s3_class(ch_history(), "ch_history")
  expect_null(ch_history_set(NULL))
})

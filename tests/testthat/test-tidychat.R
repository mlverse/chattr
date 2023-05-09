test_that("Basic tidychat() tests", {
  expect_snapshot(tidychat::tidychat("test", preview = TRUE))
})

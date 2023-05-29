test_that("Model lists output is as expected", {
  expect_snapshot(capture.output(ch_get_ymls()))
})

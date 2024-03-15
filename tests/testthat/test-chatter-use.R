test_that("Model lists output is as expected", {
  skip("Will fix as part of the testing upgrades")
  expect_snapshot(capture.output(ch_get_ymls(menu = FALSE)))
})

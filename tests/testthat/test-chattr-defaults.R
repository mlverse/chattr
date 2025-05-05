test_that("Defaults print works", {
  test_model_backend()
  expect_snapshot(print(chattr_defaults()))
})

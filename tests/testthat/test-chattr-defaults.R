test_that("Defaults print works", {
  chattr_use("test")
  expect_snapshot(print(chattr_defaults()))
})

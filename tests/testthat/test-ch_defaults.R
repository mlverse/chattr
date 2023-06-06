test_that("Basic default tests", {
  expect_snapshot(chattr_use("llamagpt"))
  test_chattr_type_set("console")
  expect_snapshot(chattr_defaults())
  test_chattr_type_unset()
})

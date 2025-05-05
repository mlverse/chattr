test_that("Basic default tests", {
  expect_snapshot(chattr_use("ollama"))
  test_chattr_type_set("console")
  expect_snapshot(chattr_defaults())
  test_chattr_type_unset()
})

test_that("Makes sure that changing something on 'default' changes it every where", {
  expect_snapshot(chattr_use("ollama"))
  expect_snapshot(chattr_defaults(model = "test"))
  test_chattr_type_set("chat")
  x <- chattr_defaults()
  expect_equal(x$model, "test")
  expect_equal(x$type, "chat")
  test_chattr_type_unset()
})

test_that("Changing something in non-default does not impact others", {
  expect_snapshot(chattr_use("ollama"))
  chattr_defaults("chat", model = "test")
  x <- chattr_defaults("console")
  expect_true(x$model != "test")
})

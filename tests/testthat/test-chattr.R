test_that("chattr() works", {
  chattr_use("test")
  local_mocked_bindings(
    ui_current = function(...) {
      "console"
    }
  )
  expect_output(chattr("hello"), "hello")
  expect_output(chattr("hello", stream = FALSE), "hello")
})

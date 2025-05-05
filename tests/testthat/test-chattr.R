test_that("chattr() works", {
  test_model_backend()
  local_mocked_bindings(
    ui_current = function(...) {
      "console"
    }
  )
  expect_output(chattr("hello"), "hello")
  expect_output(chattr("hello", stream = FALSE), "hello")
})

test_that("chattr() works", {
  def <- test_simulate_model("gpt35.yml")
  class(def) <- c("test_backend", "ch_model")

  local_mocked_bindings(
    chattr_defaults = function(...) def
  )
  expect_silent(chattr("hello"))
  expect_output(chattr("hello", stream = FALSE))
})

test_that("chattr() works", {
  def <- test_simulate_model("gpt35.yml")
  class(def) <- c("test_backend", "ch_model")

  local_mocked_bindings(
    chattr_defaults = function(...) def,
    ui_current = function(...) "script"
  )
  expect_silent(chattr("hello"))
})

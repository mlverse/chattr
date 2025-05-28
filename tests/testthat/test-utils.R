test_that("Creation and printing ch_request objects", {
  def <- test_simulate_model("gpt41.yml")
  x <- list()
  x$provider <- "Test Provider"
  x$type <- "chat"
  expect_snapshot(as_ch_request(x, def))
})

test_that("UI Validation works", {
  expect_error(ui_validate("hello"))
})

test_that("OS functions work", {
  expect_true(
    os_get() %in% c("mac", "win", "unix")
  )
})

test_that("Print history works", {
  expect_snapshot(
    print_history(list(list(role = "user", content = "test")))
  )
})

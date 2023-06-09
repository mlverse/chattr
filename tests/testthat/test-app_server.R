test_that("Split content function", {
  content <- readRDS(package_file("history", "raw.rds"))[[2]]$content
  expect_snapshot(app_split_content(content))
})

test_that("Prep-entry works", {
  x <- prep_entry(c("a", "b", "c"), TRUE)
  expect_true(length(x) == 1)
})

test_that("File completion is processed", {
  msg <- "Test works"
  file <- tempfile()
  saveRDS(msg, file)
  expect_equal(
    app_server_file_complete(file),
    msg
  )
})

test_that("File stream is processed", {
  msg <- "Test works"
  file <- tempfile()
  saveRDS(msg, file)
  app_server_file_stream(file)
  expect_equal(
    ch_env$current_stream,
    msg
  )
})

test_that("Cleanup", {
  expect_null(ch_history_set(NULL))
})

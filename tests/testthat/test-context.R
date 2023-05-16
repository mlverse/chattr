test_that("Data frames context", {
  expect_snapshot(context_data_frames())
})

test_that("File finder works", {
  context_data_files("R") %>%
    cat() %>%
    expect_snapshot()
})

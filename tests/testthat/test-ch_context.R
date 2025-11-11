test_that("Data frames context", {
  ch_context_data_frames() |>
    cat() |>
    expect_snapshot()

  ch_context_data_frames(max = 1) |>
    cat() |>
    expect_snapshot()
})

test_that("File finder works", {
  expect_snapshot(ch_context_data_files(file_types = "R"))

  expect_snapshot(ch_context_data_files(max = 2, file_types = "R"))
})

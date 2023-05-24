test_that("Data frames context", {
  data(mtcars)
  data(iris)

  ch_context_data_frames() %>%
    cat() %>%
    expect_snapshot()

  ch_context_data_frames(max = 1) %>%
    cat() %>%
    expect_snapshot()
})

test_that("File finder works", {
  ch_context_data_files(file_types = "R") %>%
    cat() %>%
    expect_snapshot()

  ch_context_data_files(max = 2, file_types = "R") %>%
    cat() %>%
    expect_snapshot()
})

test_that("Split content function", {
  content <- readRDS(package_file("history", "raw.rds"))[[2]]$content
  expect_snapshot(app_split_content(content))
})

test_that("Prep-entry works", {
  x <- prep_entry(c("a", "b", "c"))
  expect_true(length(x) == 1)
})

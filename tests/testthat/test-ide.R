test_that("Testing IDE functions", {
  expect_equal(ide_current(), "")
  expect_false(ide_is_rstudio())
  expect_equal(ui_current(), "console")
  expect_false(ui_current_markdown())
})

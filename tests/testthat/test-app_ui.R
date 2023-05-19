test_that("UI output is as expected",  {
  out <- capture.output(app_ui())
  # Removing lines with tabsetid to avoid failures due
  # to the ID number actually changing every time it
  # runs
  tabsets <- grepl("data-tabsetid", out)
  out <- out[!tabsets]
  expect_snapshot(out)
})

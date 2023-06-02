test_that("Set to GPT3.5", {
  expect_snapshot(chattr_use("gpt35"))
})

test_that("UI output is as expected", {
  out <- capture.output(app_ui())
  # Removing lines with tabsetid to avoid failures due
  # to the ID number actually changing every time it
  # runs
  tabsets <- grepl("data-tabsetid", out)
  out <- out[!tabsets]
  expect_snapshot(out)
})

test_that("UI modal output is as expected", {
  expect_snapshot(capture.output(app_ui_modal()))
})

test_that("UI entry for assistant reponse works as expected", {
  ch_debug_set_true()
  expect_true(ch_debug_get())
  expect_snapshot(capture.output(app_ui_entry("test", TRUE, 1)))
  expect_snapshot(capture.output(app_ui_entry("test", FALSE, 2)))
  ch_debug_set_false()
  expect_false(ch_debug_get())
})

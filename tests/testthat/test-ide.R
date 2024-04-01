test_that("Testing IDE functions", {
  ch_debug_set_false()
  expect_false(ch_debug_get())
  expect_false(ide_is_rstudio())
  expect_equal(ui_current(), "console")
  expect_false(ui_current_markdown())
})

test_that("IDE functions work in debug mode", {
  script <- readRDS(package_file("tests", "rstudio-script.rds"))
  ch_debug_set_true()
  expect_true(ch_debug_get())
  expect_true(ide_is_rstudio())
  expect_equal(ui_current(), "script")
  expect_false(ui_current_console())
  expect_false(ui_current_markdown())
  expect_equal(ide_comment_selection(), script$contents)
  ch_debug_set_false()
  expect_false(ch_debug_get())
})

test_that("Paste text works", {
  local_mocked_bindings(
    insertText = function(...) return("test"),
    ide_is_rstudio = function(...) TRUE
  )
  expect_silent(ide_paste_text("hello"))
})

test_that("IDE builder works", {
  expect_equal(ide_build_prompt("test"), "test")
})

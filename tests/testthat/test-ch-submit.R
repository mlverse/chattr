skip_on_covr()
test_that("Submit job works as expected", {
  Sys.setenv("CHATTR_TYPE" = "console")
  ch_debug_set_true()
  expect_true(ch_debug_get())

  complete_file <- tempfile()

  expect_silent(
    ch_submit_job(
      prompt = "TEST",
      stream = TRUE,
      prompt_build = TRUE,
      r_file_stream = tempfile(),
      r_file_complete = complete_file,
      defaults = chattr_defaults()
    )
  )

  expect_silent(ch_submit_job_stop())

  expect_false(is.null(r_session_get()))

  expect_equal(
    ch_env$r_session$get_state(),
    "finished"
  )

  ch_debug_set_false()
  expect_false(ch_debug_get())

  Sys.unsetenv("CHATTR_TYPE")
})

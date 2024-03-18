test_that("Submit job works as expected", {
  Sys.setenv("CHATTR_TYPE" = "console")
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

  Sys.unsetenv("CHATTR_TYPE")
})

test_that("Sets to LLamaGPT model", {
  expect_snapshot(chattr_use("llamagpt"))
})

test_that("Session management works", {
  expect_false(ch_llamagpt_stop())


  x <- list()
  x$kill <- function() TRUE
  x$is_alive <- function() TRUE
  x$read_error <- function() ""
  ch_env$llamagpt$session <- x

  expect_named(ch_llamagpt_session())
  expect_snapshot(chattr_test(defaults = chattr_defaults()))
  expect_true(ch_llamagpt_stop())

  ch_env$llamagpt$session <- NULL
})


test_that("Args output is correct", {
  out <- ch_llamagpt_args(chattr_defaults())
  model_line <- grepl("ggml-gpt4all-j-v1.3-groovy.bin", out)
  # Removes expanded path because it will be different based
  # on the user who is running the tests
  out <- out[!model_line]
  expect_snapshot(out)
})

test_that("Printout works", {
  test_chattr_type_set("console")
  expect_snapshot(
    ch_llamagpt_printout(chattr_defaults(), output = "xxx\n> ")
  )
  test_chattr_type_unset()
})

test_that("Console works", {
  expect_snapshot(
    capture.output(
      ch_llamagpt_output(
        stream_to = "console",
        output = "xxx\n> "
      )
    )
  )
})

test_that("Chat works", {
  chat_file <- tempfile()
  expect_null(
    ch_llamagpt_output(
      stream_to = "chat",
      stream_file = tempfile(),
      output_file = chat_file,
      output = "xxx\n> "
    )
  )
  expect_equal(readRDS(chat_file), "xxx\n")
})

test_that("Restore to previews defaults", {
  expect_snapshot(chattr_use("gpt35"))
})

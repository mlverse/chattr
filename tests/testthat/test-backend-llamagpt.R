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
  expect_snapshot(ch_test(defaults = ch_defaults()))
  expect_true(ch_llamagpt_stop())

  ch_env$llamagpt$session <- NULL
})


test_that("Args output is correct", {
  expect_snapshot(ch_llamagpt_args(ch_defaults()))
})

test_that("Printout works", {
  expect_snapshot(
    ch_llamagpt_printout(ch_defaults(), output = "xxx\n> ")
  )
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

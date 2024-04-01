test_that("Submit method works", {
  local_mocked_bindings(
    ch_llamagpt_output = function(...) {
      return("test return")
    },
    ch_llamagpt_session = function(...) invisible(),
    ch_llamagpt_prompt = function(...) invisible()
  )
  def <- test_simulate_model("llamagpt.yml")
  expect_equal(
    ch_submit(def, "test"),
    "test return"
  )
  expect_snapshot(
    ch_submit(def, "test", preview = TRUE)
  )
  def$include_history <- FALSE
  expect_snapshot(
    ch_submit(def, "test", preview = TRUE)
  )
  expect_equal(
    ch_submit(def, "test", preview = TRUE, prompt_build = FALSE),
    "test"
  )
})

test_that("Session management works", {
  x <- list()
  x$kill <- function() TRUE
  x$is_alive <- function() TRUE
  x$read_error <- function() ""
  ch_env$llamagpt$session <- x
  def <- test_simulate_model("llamagpt.yml")
  temp_folder <- tempdir()
  def$path <- temp_folder
  def$model_arguments <- c("e" = "print('hello')")
  expect_named(ch_llamagpt_session(defaults = def))
  ch_env$llamagpt$session <- NULL
})

test_that("Printout works", {
  local_mocked_bindings(
    ch_llamagpt_output = function(...) {
      return("test return")
    }
  )
  def <- test_simulate_model("llamagpt.yml")
  expect_snapshot(
    ch_llamagpt_printout(def, output = "xxx")
  )
  def$type <- "chat"
  expect_snapshot(
    ch_llamagpt_printout(def, output = "xxx")
  )
})

test_that("Args output is correct", {
  def <- test_simulate_model("llamagpt.yml")
  out <- ch_llamagpt_args(def)
  model_line <- grepl("ggml-gpt4all-j-v1.3-groovy.bin", out)
  # Removes expanded path because it will be different based
  # on the user who is running the tests
  out <- out[!model_line]
  expect_snapshot(out)
})

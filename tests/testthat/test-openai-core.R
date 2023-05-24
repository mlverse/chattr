test_that("Request submission works",{
  Sys.setenv("OPENAI_API_KEY" = "test")
  expect_snapshot(openai_request("chat/completions", list()))
})

test_that("Missing token returns error", {
  Sys.unsetenv("OPENAI_API_KEY")
  expect_error(openai_token())
})

test_that("Stream parser works", {
  raw <- readRDS(test_path("data", "gpt35-stream.rds"))
  stream <- openai_stream_parse(raw, "chat/completions")
  msg_gpt <- paste(
    "I'm sorry, I don't understand what you are asking for.",
    "Could you please provide more information or a specific",
    "task for me to assist you with?"
  )

  expect_equal(stream, msg_gpt)

  out <- raw %>%
    charToRaw() %>%
    openai_stream_ide_delta("chat/completions", testing = TRUE)

  expect_equal(out, msg_gpt)

  out2 <- raw %>%
    charToRaw() %>%
    openai_stream_ide_delta("chat/completions", testing = TRUE)

  expect_equal(out2, paste0(msg_gpt, msg_gpt))
})

test_that("Stream file parser works", {
  raw <- readRDS(test_path("data", "gpt35-stream.rds"))
  stream <- openai_stream_parse(raw, "chat/completions")
  msg_gpt <- paste(
    "I'm sorry, I don't understand what you are asking for.",
    "Could you please provide more information or a specific",
    "task for me to assist you with?"
  )

  expect_equal(stream, msg_gpt)

  out_file <- tempfile()

  openai_stream_file_delta(
    x = charToRaw(raw),
    endpoint = "chat/completions",
    r_file_stream = out_file
  )

  out_response <- readRDS(out_file)

  expect_equal(out_response, msg_gpt)
})

test_that("Error handling works", {
  x <- readRDS(test_path("data/gpt35-error.rds"))
  parsed <- openai_stream_parse(x, "chat/completions")
  expect_snapshot(parsed)
  expect_error(openai_check_error(parsed))
  expect_error(openai_check_error(parsed))
})


test_that("Request submission works", {
  Sys.setenv("OPENAI_API_KEY" = "test")
  expect_snapshot(openai_request(chattr_defaults(), list()))
})

test_that("Missing token returns error", {
  Sys.unsetenv("OPENAI_API_KEY")
  expect_error(openai_token())
})

test_that("Stream parser works", {
  raw <- readRDS(test_path("data", "gpt35-stream.rds"))
  stream <- openai_stream_parse(raw, chattr_defaults())
  msg_gpt <- paste(
    "I'm sorry, I don't understand what you are asking for.",
    "Could you please provide more information or a specific",
    "task for me to assist you with?"
  )

  expect_equal(stream, msg_gpt)

  out <- raw %>%
    charToRaw() %>%
    openai_parse_ide(chattr_defaults(), testing = TRUE)

  expect_equal(out, msg_gpt)

  out2 <- raw %>%
    charToRaw() %>%
    openai_parse_ide(chattr_defaults(), testing = TRUE)

  expect_equal(out2, paste0(msg_gpt, msg_gpt))
})

test_that("Stream file parser works", {
  raw <- readRDS(test_path("data", "gpt35-stream.rds"))
  stream <- openai_stream_parse(raw, chattr_defaults())
  msg_gpt <- paste(
    "I'm sorry, I don't understand what you are asking for.",
    "Could you please provide more information or a specific",
    "task for me to assist you with?"
  )

  expect_equal(stream, msg_gpt)

  out_file <- tempfile()

  openai_parse_file(
    defaults = chattr_defaults(),
    x = charToRaw(raw),
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

test_that("Warning messages appear", {
  expect_snapshot(
    app_init_message.cl_openai(
      list(
        title = "test",
        max_data_files = 10,
        max_data_frames = 10
      )
    )
  )
})

test_that("Copilot stream content is parsed", {
  expect_equal(
    openai_stream_content.ch_openai_github_copilot_chat(
      list(),
      list(list(choices = list(delta = list(content = "test"))))
    ),
    "test"
  )
})

test_that("OpenAI stream content is parsed", {
  expect_equal(
    openai_stream_content.ch_openai_completions(
      list(),
      list(list(choices = list(text = "test")))
    ),
    "test"
  )
})

test_that("OpenAI error check works", {
  expect_silent(openai_check_error(NULL))
  expect_silent(openai_check_error(1:2))
  expect_error(openai_check_error("{{error}} test"))
})

test_that("Copilot httr2 request works", {
  local_mocked_bindings(
    openai_token = function(...) "",
  )
  expect_snapshot(
    openai_request.ch_openai_github_copilot_chat(
      defaults = list(path = "url"),
      req_body = list()
    )
  )
})

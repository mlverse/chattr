test_that("Missing token returns error", {
  Sys.unsetenv("OPENAI_API_KEY")
  expect_error(openai_token())
})

test_that("Stream parser works", {
  raw <- readRDS(test_path("data", "gpt35-stream.rds"))
  stream <- openai_stream_parse(raw, "chat/completions")
  expect_equal(
    stream,
    paste(
      "I'm sorry, I don't understand what you are asking for.",
      "Could you please provide more information or a specific",
      "task for me to assist you with?"
    )
  )
})

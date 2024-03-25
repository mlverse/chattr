test_that("Using 'chat'", {
  withr::with_envvar(
    new = c("OPENAI_API_KEY" = "test"),
    {
      local_mocked_bindings(
        req_perform = httr2::req_dry_run
      )
      defaults <- yaml::read_yaml(package_file("configs", "gpt35.yml"))
      defaults <- as_ch_model(defaults$default, "chat")
      expect_error(
        openai_switch(
          prompt = "test",
          req_body = defaults$model_arguments,
          defaults = defaults,
          r_file_stream = tempfile(),
          r_file_complete = tempfile()
        )
      )
    }
  )
})

test_that("Using 'console'", {
  withr::with_envvar(
    new = c("OPENAI_API_KEY" = "test"),
    {
      local_mocked_bindings(
        req_perform_stream = function(...) {
          ch_env$stream$response <- "test"
        }
      )
      defaults <- yaml::read_yaml(package_file("configs", "gpt35.yml"))
      defaults <- as_ch_model(defaults$default, "console")
      expect_silent(
        openai_switch(
          prompt = "test",
          req_body = defaults$model_arguments,
          defaults = defaults,
          r_file_stream = tempfile(),
          r_file_complete = tempfile()
        )
      )
    }
  )
})

test_that("Submit method works", {
  local_mocked_bindings(
    ch_openai_complete = function(...) return("test return")
  )
  def <- test_simulate_model("gpt35.yml")
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
})

test_that("Completion function works", {
  withr::with_envvar(
    new = c("OPENAI_API_KEY" = "test"),
    {
      local_mocked_bindings(
        req_perform_stream = function(...) {
          x <- list()
          x$status_code <- 200
          x
        }
      )
      def <- test_simulate_model("gpt35.yml")
      expect_null(
        ch_openai_complete(
          prompt = "test",
          defaults = def,
        )
      )
    }
  )
})

test_that("Error when status is not 200", {
  withr::with_envvar(
    new = c("OPENAI_API_KEY" = "test"),
    {
      local_mocked_bindings(
        req_perform_stream = function(...) {
          x <- list()
          x$status_code <- 400
          x
        }
      )
      def <- test_simulate_model("gpt35.yml")
      expect_error(
        ch_openai_complete(
          prompt = "test",
          defaults = def,
        )
      )
    }
  )
})

test_that("Completion function works for Copilot", {
  withr::with_envvar(
    new = c("OPENAI_API_KEY" = "test"),
    {
      local_mocked_bindings(
        req_perform_stream = function(...) {
          x <- list()
          x$status_code <- 200
          x
        },
        ch_gh_token = function(...) "token"
      )
      def <- test_simulate_model("copilot.yml")
      expect_null(
        ch_openai_complete(
          prompt = "test",
          defaults = def,
        )
      )
    }
  )
})

test_that("Copilot token finder works", {
  local_mocked_bindings(
    req_perform = httr2::req_dry_run,
    resp_body_json = function(...) {
      ret <- list()
      ret$token <- "12345"
      ret
    }
  )
  temp_folder <- tempdir()
  temp_hosts <- "{\"github.com\":{\"user\":\"testuser\",\"oauth_token\":\"testtoken\"}}"
  writeLines(temp_hosts, con = path(temp_folder, "hosts.json"))
  defaults <- test_simulate_model("copilot.yml")
  defaults$hosts_path <- temp_folder

  expect_output(
    out <- ch_gh_token(defaults),
    regexp = "GET /copilot_internal/v2/token HTTP/1.1"
  )
  expect_equal(out, "12345")

  def_errors <- defaults
  if (!is.na(Sys.getenv("CI", unset = NA))) {
    def_errors$hosts_path <- NULL
    expect_error(ch_gh_token(def_errors), "There is no default")
  }
  def_errors$hosts_path <- ""
  def_errors$token_url <- NULL
  expect_error(ch_gh_token(def_errors), "There is no default GH")
})

test_that("Copilot token folder not found", {
  local_mocked_bindings(
    os_win = function(...) TRUE
  )
  defaults <- test_simulate_model("copilot.yml")
  defaults$hosts_path <- NULL
  expect_error(ch_gh_token())
})

test_that("OpenAI token finder works", {
  withr::with_envvar(
    new = c("OPENAI_API_KEY" = "12345"),
    expect_equal(ch_openai_token(list()), "12345")
  )
  config_file <- path(tempdir(), "config.yml")
  yaml::write_yaml(list(default = list("openai-api-key" = "12345")), config_file)
  withr::with_envvar(
    new = c("R_CONFIG_FILE" = config_file, "OPENAI_API_KEY" = NA),
    expect_equal(ch_openai_token(list()), "12345")
  )
})

test_that("Missing token returns error", {
  withr::with_envvar(
    new = c("OPENAI_API_KEY" = NA),
    expect_error(ch_openai_token(d))
  )
})

test_that("Error handling works", {
  x <- readRDS(test_path("data/gpt35-error.rds"))
  parsed <- ch_openai_parse(x, "chat/completions")
  expect_snapshot(parsed)
  expect_error(ch_openai_error(parsed))
})

skip()

test_that("Init messages work", {
  expect_snapshot(chattr_use("gpt35"))
  chattr_defaults(max_data_files = 10, max_data_frames = 10)
  expect_snapshot(app_init_message(chattr_defaults()))
  expect_snapshot(chattr_use("llamagpt"))
  expect_snapshot(app_init_message(chattr_defaults()))
})


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
          x <- list()
          x$status_code <- 200
          x
        }
      )
      defaults <- yaml::read_yaml(package_file("configs", "gpt35.yml"))
      defaults <- as_ch_model(defaults$default, "console")
      expect_null(
        ch_openai_complete(
          prompt = "test",
          defaults = defaults,
        )
      )
    }
  )
})



test_that("Stream parser works", {
  raw <- readRDS(test_path("data", "gpt35-stream.rds"))
  msg_gpt <- paste(
    "I'm sorry, I don't understand what you are asking for.",
    "Could you please provide more information or a specific",
    "task for me to assist you with?"
  )

  expect_equal(ch_openai_parse(raw, chattr_defaults()), msg_gpt)
})

test_that("Error handling works", {
  x <- readRDS(test_path("data/gpt35-error.rds"))
  parsed <- ch_openai_parse(x, "chat/completions")
  expect_snapshot(parsed)
  expect_error(ch_openai_error(parsed))
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

test_that("OpenAI error check works", {
  expect_silent(ch_openai_error(NULL))
  expect_silent(ch_openai_error(1:2))
  expect_error(ch_openai_error("{{error}} test"))
})



# ----------------------------------- Copilot ----------------------------------



skip()

test_that("Completions works", {
  local_mocked_bindings(
    openai_switch = function(...) "test"
  )
  defaults <- yaml::read_yaml(package_file("configs", "copilot.yml"))
  defaults <- as_ch_model(defaults$default, "chat")
  expect_equal(
    openai_completion.ch_openai_github_copilot_chat(
      prompt = "test",
      new_prompt = "newtest",
      defaults = defaults,
      r_file_stream = tempfile(),
      r_file_complete = tempfile()
    ),
    "test"
  )
})

test_that("Copilot httr2 request works", {
  local_mocked_bindings(
    openai_token = function(...) ""
  )
  expect_snapshot(
    openai_request.ch_openai_github_copilot_chat(
      defaults = list(path = "url"),
      req_body = list()
    )
  )
})

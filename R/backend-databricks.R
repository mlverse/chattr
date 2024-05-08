#' @export
ch_submit.ch_databricks <- function(
    defaults,
    prompt = NULL,
    stream = NULL,
    prompt_build = TRUE,
    preview = FALSE,
    ...) {
  if (prompt_build) {
    # re-use OpenAI prompt
    prompt <- ch_openai_prompt(defaults, prompt)
  }
  ret <- NULL
  if (preview) {
    ret <- prompt
  } else {
    ret <- ch_databricks_complete(
      prompt = prompt,
      defaults = defaults
    )
  }
  ret
}


ch_databricks_complete <- function(prompt, defaults, stream = TRUE) {
  ret <- NULL
  req_body <- c(
    list(messages = prompt),
    defaults$model_arguments
  )

  token <- ch_databricks_token(defaults)
  host <- ch_databricks_host(defaults)
  user_agent <-paste0("chattr/", utils::packageVersion('chattr'))

  req_result <- host %>%
    request() %>%
    req_url_path_append(defaults$path) %>%
    req_url_path_append(defaults$model) %>%
    req_url_path_append("invocations") %>%
    req_auth_bearer_token(token) %>%
    req_user_agent(user_agent) %>%
    req_body_json(req_body)

  req_result <- req_result %>%
    req_perform_stream(
      function(x) {
        char_x <- rawToChar(x)
        ret <<- paste0(ret, char_x)
        # print(ret)
        cat(ch_openai_parse(char_x, defaults))
        TRUE
      },
      buffer_kb = 0.05, round = "line"
    )
  ret <- ch_openai_parse(ret, defaults)
  if (req_result$status_code != 200) {
    ch_openai_error(ret, use_abort = FALSE)
    if (inherits(req_result, "httr2_response")) {
      req_result <- paste0(
        resp_status(req_result),
        " - ",
        resp_status_desc(req_result)
      )
    }
    if (!inherits(req_result, "character")) {
      req_result <- "Undefined error"
    }
    cli_abort(req_result, call = NULL)
  }
  ch_openai_error(ret)
  ret
}

ch_databricks_token <- function(defaults, fail = TRUE) {
  env_key <- Sys.getenv("DATABRICKS_TOKEN", unset = NA)
  ret <- NULL
  if (!is.na(env_key)) {
    ret <- env_key
  }
  if (is.null(ret) && file_exists(Sys.getenv("R_CONFIG_FILE", "config.yml"))) {
    ret <- config::get("databricks-token")
  }
  if (is.null(ret) && fail) {
    abort(
      "No token found
    - Add your key to the \"DATABRICKS_TOKEN\" environment variable
    - or - Add  \"databricks-token\" to a `config` YAML file"
    )
  }
  ret
}

ch_databricks_host <- function(defaults, fail = TRUE) {
  env_key <- Sys.getenv("DATABRICKS_HOST", unset = NA)
  ret <- NULL
  if (!is.na(env_key)) {
    ret <- env_key
  }
  if (is.null(ret) && file_exists(Sys.getenv("R_CONFIG_FILE", "config.yml"))) {
    ret <- config::get("databricks-host")
  }
  if (is.null(ret) && fail) {
    abort(
      "No host found
    - Add your workspace url to the \"DATABRICKS_HOST\" environment variable
    - or - Add  \"databricks-host\" to a `config` YAML file"
    )
  }
  ret
}

#' @export
app_init_message.ch_databricks <- function(defaults) {
  print_provider(defaults)
  if (defaults$max_data_files > 0) {
    cli_alert_warning(
      paste0(
        "A list of the top {defaults$max_data_files} files will ",
        "be sent externally to Databricks with every request\n",
        "To avoid this, set the number of files to be sent to 0 ",
        "using {.run chattr::chattr_defaults(max_data_files = 0)}"
      )
    )
  }

  if (defaults$max_data_frames > 0) {
    cli_alert_warning(
      paste0(
        "A list of the top {defaults$max_data_frames} data.frames ",
        "currently in your R session will be sent externally to ",
        "Databricks with every request\n To avoid this, set the number ",
        "of data.frames to be sent to 0 using ",
        "{.run chattr::chattr_defaults(max_data_frames = 0)}"
      )
    )
  }
}

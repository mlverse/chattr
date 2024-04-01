#' @export
ch_submit.ch_openai <- function(
    defaults,
    prompt = NULL,
    stream = NULL,
    prompt_build = TRUE,
    preview = FALSE,
    ...) {
  if (prompt_build) {
    prompt <- ch_openai_prompt(defaults, prompt)
  }
  ret <- NULL
  if (preview) {
    ret <- prompt
  } else {
    ret <- ch_openai_complete(
      prompt = prompt,
      defaults = defaults
    )
  }
  ret
}

ch_openai_prompt <- function(defaults, prompt) {
  header <- c(
    process_prompt(defaults$prompt),
    ch_context_data_files(defaults$max_data_files),
    ch_context_data_frames(defaults$max_data_frames)
  )
  header <- paste0("* ", header, collapse = " \n")
  system_msg <- defaults$system_msg
  if (!is.null(system_msg)) {
    system_msg <- list(list(role = "system", content = defaults$system_msg))
  }

  if (defaults$include_history) {
    history <- ch_history()
  } else {
    history <- NULL
  }
  ret <- c(
    system_msg,
    history,
    list(list(role = "user", content = paste0(header, "\n", prompt)))
  )
  ret
}

ch_openai_complete <- function(prompt, defaults, stream = TRUE) {
  ret <- NULL
  req_body <- c(
    list(messages = prompt),
    model = defaults$model,
    defaults$model_arguments
  )

  if (ch_openai_is_copilot(defaults)) {
    token <- ch_gh_token(defaults)
  } else {
    token <- ch_openai_token(defaults)
  }

  req_result <- defaults$path %>%
    request() %>%
    req_auth_bearer_token(token) %>%
    req_body_json(req_body)

  if (ch_openai_is_copilot(defaults)) {
    req_result <- req_headers(req_result, "Editor-Version" = "vscode/9.9.9")
  }

  req_result <- req_result %>%
    req_perform_stream(
      function(x) {
        char_x <- rawToChar(x)
        ret <<- paste0(ret, char_x)
        cat(ch_openai_parse(char_x, defaults))
        TRUE
      },
      buffer_kb = 0.05, round = "line"
    )
  ret <- ch_openai_parse(ret, defaults)
  if (req_result$status_code != 200) {
    cli_alert_warning(ret)
    abort(req_result)
  }
  ch_openai_error(ret)
  ret
}

ch_gh_token <- function(defaults = NULL, fail = TRUE) {
  ret <- NULL
  if (ch_debug_get()) {
    return("")
  }

  hosts_path <- defaults$hosts_path

  if (is.null(hosts_path)) {
    if (os_win()) {
      possible_path <- path(Sys.getenv("localappdata"), "github-copilot")
    } else {
      possible_path <- "~/.config/github-copilot"
    }
    if (dir_exists(possible_path)) {
      hosts_path <- possible_path
    }
  }

  token_url <- defaults$token_url
  if (is.null(hosts_path) && fail) {
    abort(
      c(
        "There is no default for the RStudio GitHub Copilot configuration folder",
        "Please add a 'hosts_path' to your YAML file, or to chattr_defaults() "
      )
    )
  }
  if (is.null(token_url) && fail) {
    abort(
      c(
        "There is no default GH Copilot token URL",
        "Please add a 'token_url' to your YAML file, or to chattr_defaults() "
      )
    )
  }
  if (is.null(hosts_path)) {
    return(NULL)
  }
  gh_path <- path_expand(hosts_path)
  if (dir_exists(gh_path)) {
    hosts <- jsonlite::read_json(path(gh_path, "hosts.json"))
    oauth_token <- hosts[[1]]$oauth_token
    x <- try(
      {
        request(token_url) %>%
          req_auth_bearer_token(oauth_token) %>%
          req_perform()
      },
      silent = TRUE
    )
    if (inherits(x, "try-error")) {
      if (fail) {
        abort(x)
      } else {
        return(NULL)
      }
    }
    x_json <- resp_body_json(x)
    ret <- x_json$token
  } else {
    if (fail) {
      abort("Please setup GitHub Copilot for RStudio first")
    }
  }
  ret
}

ch_openai_token <- function(defaults, fail = TRUE) {
  env_key <- Sys.getenv("OPENAI_API_KEY", unset = NA)
  ret <- NULL
  if (!is.na(env_key)) {
    ret <- env_key
  }
  if (is.null(ret) && file_exists(Sys.getenv("R_CONFIG_FILE", "config.yml"))) {
    ret <- config::get("openai-api-key")
  }
  if (is.null(ret) && fail) {
    abort(
      "No token found
    - Add your key to the \"OPENAI_API_KEY\" environment variable
    - or - Add  \"openai-api-key\" to a `config` YAML file"
    )
  }
  ret
}

ch_openai_error <- function(x) {
  if (is.null(x)) {
    return(invisible())
  }
  if (length(x) > 1) {
    return(invisible())
  }
  if (substr(x, 1, 9) == "{{error}}") {
    error_msg <- paste0(
      "Error from OpenAI\n",
      substr(x, 10, nchar(x))
    )
    abort(error_msg)
  }
  invisible()
}

ch_openai_parse <- function(x, defaults) {
  res <- x %>%
    paste0(collapse = "") %>%
    strsplit("data: ") %>%
    unlist() %>%
    discard(~ .x == "") %>%
    keep(~ substr(.x, (nchar(.x) - 2), nchar(.x)) == "}\n\n") %>%
    map(jsonlite::fromJSON)

  out <- NULL
  if (length(res) > 0) {
    content <- res %>%
      map(~ {
        content <- .x$choices$delta$content
        if (is_na(content)) content <- ""
        content
      }) %>%
      reduce(paste0)

    if (length(content) > 0) {
      out <- content
    }
  } else {
    json_res <- try(jsonlite::fromJSON(x), silent = TRUE)
    if (!inherits(json_res, "try-error")) {
      if ("error" %in% names(json_res)) {
        json_error <- json_res$error
        out <- paste0(
          "{{error}}Type:",
          json_error$type,
          "\nMessage: ",
          json_error$message
        )
      }
    }
  }
  out
}

ch_openai_is_copilot <- function(defaults) {
  grepl("copilot", tolower(defaults$provider))
}

#' @export
app_init_message.ch_openai <- function(defaults) {
  print_provider(defaults)
  if (defaults$max_data_files > 0) {
    cli_alert_warning(
      paste0(
        "A list of the top {defaults$max_data_files} files will ",
        "be sent externally to OpenAI with every request\n",
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
        "OpenAI with every request\n To avoid this, set the number ",
        "of data.frames to be sent to 0 using ",
        "{.run chattr::chattr_defaults(max_data_frames = 0)}"
      )
    )
  }
}

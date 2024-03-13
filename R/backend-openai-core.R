openai_token <- function(defaults) {
  UseMethod("openai_token")
}

openai_token.ch_openai_copilot_chat <- function(defaults) {
  if (ch_debug_get()) {
    return("")
  }
  hosts_path <- defaults$hosts_path
  token_url <- defaults$token_url
  if(is.null(hosts_path)) {
    abort(
      c(
        "There is no default for the RStudio GitHub Copilot configuration folder",
        "Please add a 'hosts_path' to your YAML file, or to chattr_defaults() "
      ))
  }
  if(is.null(token_url)) {
    abort(
      c(
        "There is no default the GH Copilot token URL",
        "Please add a 'token_url' to your YAML file, or to chattr_defaults() "
      ))
  }
  gh_path <- path_expand(hosts_path)
  if (dir_exists(gh_path)) {
    hosts <- jsonlite::read_json(path(gh_path, "hosts.json"))
    oauth_token <- hosts[[1]]$oauth_token
    x <- request(token_url) %>%
      req_auth_bearer_token(oauth_token) %>%
      req_perform()
    x_json <- resp_body_json(x)
    return(x_json$token)
  } else {
    abort("Please setup GitHub Copilot for RStudio first")
  }
}

openai_token.ch_openai <- function(defaults) {
  if (ch_debug_get()) {
    return("")
  }
  env_key <- Sys.getenv("OPENAI_API_KEY", unset = NA)
  ret <- NULL
  if (!is.na(env_key)) {
    ret <- env_key
  }
  if (is.null(ret) && file_exists(Sys.getenv("R_CONFIG_FILE", "config.yml"))) {
    ret <- config::get("openai-api-key")
  }
  if (is.null(ret)) {
    abort(
      "No token found
    - Add your key to the \"OPENAI_API_KEY\" environment variable
    - or - Add  \"openai-api-key\" to a `config` YAML file"
    )
  }
  ret
}

openai_request <- function(defaults, req_body) {
  UseMethod("openai_request")
}

openai_request.ch_openai <- function(defaults, req_body) {
  defaults$path %>%
    request() %>%
    req_auth_bearer_token(openai_token(defaults = defaults)) %>%
    req_body_json(req_body)
}

openai_request.ch_openai_copilot_chat <- function(defaults, req_body) {
  defaults$path %>%
    request() %>%
    req_auth_bearer_token(openai_token(defaults = defaults)) %>%
    req_body_json(req_body) %>%
    req_headers("Editor-Version" = "vscode/9.9.9")
}

openai_check_error <- function(x) {
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

openai_stream_parse <- function(x, defaults) {
  res <- x %>%
    paste0(collapse = "") %>%
    strsplit("data: ") %>%
    unlist() %>%
    discard(~ .x == "") %>%
    keep(~ substr(.x, (nchar(.x) - 2), nchar(.x)) == "}\n\n") %>%
    map(jsonlite::fromJSON)

  out <- NULL
  if (length(res) > 0) {
    content <- openai_stream_content(defaults, res)
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

openai_stream_content <- function(defaults, res) {
  UseMethod("openai_stream_content")
}

openai_stream_content.ch_openai_chat_completions <- function(defaults, res) {
  res %>%
    map(~ .x$choices$delta$content) %>%
    reduce(paste0)
}

openai_stream_content.ch_openai_completions <- function(defaults, res) {
  res %>%
    map(~ .x$choices$text) %>%
    reduce(paste0)
}

openai_stream_content.ch_openai_copilot_chat <- function(defaults, res) {
  res %>%
    map(~ {
      content <- .x$choices$delta$content
      if (!is.null(content)) {
        if (is.na(content)) content <- ""
      }
      content
    }) %>%
    reduce(paste0)
}

is_copilot <- function(defaults) {
  grepl("copilot", tolower(defaults$provider))
}

app_init_message.cl_openai <- function(defaults) {
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

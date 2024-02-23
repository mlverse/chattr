openai_token <- function(defaults = NULL) {
  if (!is.null(defaults)) {
    if (is_copilot(defaults)) {
      gh_path <- path("~/.config/github-copilot")
      if (dir_exists(gh_path)) {
        hosts <- jsonlite::read_json(path(gh_path, "hosts.json"))
        oauth_token <- hosts[[1]]$oauth_token
        x <- request("https://api.github.com/copilot_internal/v2/token") %>%
          req_auth_bearer_token(oauth_token) %>%
          req_perform()
        x_json <- resp_body_json(x)
        return(x_json$token)
      } else {
        abort("Please setup GitHub Copilot for RStudio first")
      }
    }
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
    abort("No token found
       - Add your key to the \"OPENAI_API_KEY\" environment variable
       - or - Add  \"openai-api-key\" to a `config` YAML file")
  }

  ret
}

openai_request <- function(defaults, req_body) {
  ret <- defaults$path %>%
    httr2::request() %>%
    httr2::req_auth_bearer_token(openai_token(defaults = defaults)) %>%
    httr2::req_body_json(req_body)

  if (is_copilot(defaults)) {
    ret <- ret %>%
      req_headers("Editor-Version" = "vscode/9.9.9")
  }
  ret
}

openai_perform <- function(defaults, req_body) {
  ret <- NULL
  if (ch_debug_get()) {
    ret <- req_body
  } else {
    ret <- openai_request(defaults, req_body) %>%
      req_perform() %>%
      resp_body_json()
  }
  ret
}

openai_stream_ide <- function(defaults, req_body) {
  ch_env$stream <- list()
  ch_env$stream$raw <- NULL
  ch_env$stream$response <- NULL

  ret <- NULL
  if (ch_debug_get()) {
    ret <- req_body
  } else {
    if (!ui_current_console()) ide_paste_text("\n\n")
    openai_request(defaults, req_body) %>%
      httr2::req_perform_stream(
        function(x) {
          openai_stream_ide_delta(x, defaults)
          TRUE
        },
        buffer_kb = 0.1, round = "line"
      )
    if (!ui_current_console()) ide_paste_text("\n\n")
    ret <- ch_env$stream$response
  }
  openai_check_error(ret)
  ret
}

openai_stream_ide_delta <- function(x, defaults, testing = FALSE) {
  char_x <- rawToChar(x)
  if (is_copilot(defaults)) {
    if (grepl("Bad Request", char_x)) {
      abort(paste0("From Copilot: ", char_x))
    }
  }
  ch_env$stream$raw <- paste0(
    ch_env$stream$raw,
    char_x,
    collapse = ""
  )

  current <- openai_stream_parse(
    x = ch_env$stream$raw,
    defaults = defaults
  )

  has_error <- substr(current, 1, 9) == "{{error}}"

  if (!is.null(current)) {
    if (is.null(ch_env$stream$response)) {
      if (ui_current_console()) {
        if (!testing && !has_error) cat(current)
      } else {
        if (!testing && !has_error) ide_paste_text(current)
      }
    } else {
      if (nchar(current) != nchar(ch_env$stream$response)) {
        delta <- substr(
          current,
          nchar(ch_env$stream$response) + 1,
          nchar(current)
        )
        if (ui_current_console()) {
          if (!testing && !has_error) cat(delta)
        } else {
          for (i in 1:nchar(delta)) {
            if (!testing && !has_error) ide_paste_text(substr(delta, i, i))
          }
        }
      }
    }
  }
  ch_env$stream$response <- current
}


openai_stream_file <- function(
    defaults,
    req_body,
    r_file_stream,
    r_file_complete) {
  ch_env$stream <- list()
  ch_env$stream$response <- NULL
  ret <- NULL
  if (ch_debug_get()) {
    ret <- req_body
  } else {
    ch_env$stream$response <- NULL
    openai_request(defaults, req_body) %>%
      httr2::req_perform_stream(
        function(x) {
          openai_stream_file_delta(x, defaults, r_file_stream)
          TRUE
        },
        buffer_kb = 0.05, round = "line"
      )
    ret <- readRDS(r_file_stream)
    saveRDS(ret, r_file_complete)
    file_delete(r_file_stream)
  }
  openai_check_error(ret)
  ret
}

openai_stream_file_delta <- function(x, defaults, r_file_stream) {
  char_x <- rawToChar(x)
  if (is_copilot(defaults)) {
    if (grepl("Bad Request", char_x)) {
      abort(paste0("From Copilot: ", char_x))
    }
  }
  ch_env$stream$response <- paste0(
    ch_env$stream$response,
    char_x,
    collapse = ""
  )
  current <- openai_stream_parse(
    x = ch_env$stream$response,
    defaults = defaults
  )
  out <- ch_env$stream$response %>%
    openai_stream_parse(defaults) %>%
    saveRDS(r_file_stream)
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

openai_stream_content.ch_open_ai_chat_completions <- function(defaults, res) {
  res %>%
    map(~ .x$choices$delta$content) %>%
    reduce(paste0)
}

openai_stream_content.ch_open_ai_completions <- function(defaults, res) {
  res %>%
    map(~ .x$choices$text) %>%
    reduce(paste0)
}

openai_stream_content.ch_copilot_chat_chat_completions <- function(defaults, res) {
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

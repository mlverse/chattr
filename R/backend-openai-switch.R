openai_switch <- function(
    prompt,
    req_body,
    defaults,
    r_file_stream,
    r_file_complete) {
  ret <- NULL
  if (ch_debug_get()) {
    return(req_body)
  }
  stream <- defaults$model_arguments$stream %||% FALSE
  return_result <- TRUE
  if (stream) {
    if (defaults$type == "chat") {
      ret <- openai_stream_file(
        defaults = defaults,
        req_body = req_body,
        r_file_stream = r_file_stream,
        r_file_complete = r_file_complete
      )
    } else {
      return_result <- FALSE
      ret <- openai_stream_ide(defaults, req_body)
    }
  } else {
    ret <- openai_request(defaults, req_body) %>%
      req_perform() %>%
      resp_body_json()
  }

  if (defaults$include_history %||% FALSE) {
    assistant <- ret
    ch_history_append(prompt, assistant)
  }

  if (!return_result) {
    ret <- NULL
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
      req_perform_stream(
        function(x) {
          openai_parse_ide(x, defaults)
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

openai_parse_ide <- function(x, defaults, testing = FALSE) {
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
      req_perform_stream(
        function(x) {
          openai_parse_file(x, defaults, r_file_stream)
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

openai_parse_file <- function(x, defaults, r_file_stream) {
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
  ch_env$stream$response %>%
    openai_stream_parse(defaults) %>%
    saveRDS(r_file_stream)
}

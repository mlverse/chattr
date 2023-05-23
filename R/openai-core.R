openai_token <- function() {
  env_key <- Sys.getenv("OPENAI_API_KEY", unset = NA)

  ret <- NULL
  if (!is.na(env_key)) ret <- env_key
  if (is.null(ret)) ret <- config::get("openai-api-key")

  if (is.null(ret)) {
    stop("No token found
       - Add your key to the \"OPENAI_API_KEY\" environment variable
       - or - Add  \"open-ai-api-key\" to a `config` YAML file")
  }

  ret
}

openai_request <- function(endpoint, req_body) {
  env_url <- Sys.getenv("CHATTR_OPENAI_URL", NA)

  if(is.na(env_url)) {
    url <- "https://api.openai.com/v1/"
  } else {
    url <- env_url
  }

  url %>%
    paste0(endpoint) %>%
    request() %>%
    req_auth_bearer_token(openai_token()) %>%
    req_body_json(req_body)
}

openai_perform <- function(endpoint, req_body) {
  ret <- NULL
  if (ch_debug_get()) {
    ret <- req_body
  } else {
    ret <- openai_request(endpoint, req_body) %>%
      req_perform() %>%
      resp_body_json()
  }
  ret
}

openai_stream_ide <- function(endpoint, req_body) {
  ch_env$stream <- list()
  ch_env$stream$raw <- NULL
  ch_env$stream$response <- NULL

  ret <- NULL
  if (ch_debug_get()) {
    ret <- req_body
  } else {
    if (!ui_current_console()) ide_paste_text("\n\n")
    openai_request(endpoint, req_body) %>%
      req_stream(
        function(x) {
          openai_stream_ide_delta(x, endpoint)
          TRUE
        },
        buffer_kb = 0.1
      )
    if (!ui_current_console()) ide_paste_text("\n\n")
    ret <- ch_env$stream$response
  }
  ret
}

openai_stream_ide_delta <- function(x, endpoint, testing = FALSE) {
  ch_env$stream$raw <- paste0(
    ch_env$stream$raw,
    rawToChar(x),
    collapse = ""
  )
  current <- openai_stream_parse(
    x = ch_env$stream$raw,
    endpoint = endpoint
  )
  if (!is.null(current)) {
    if (is.null(ch_env$stream$response)) {
      if (ui_current_console()) {
        if(!testing) cat(current)
      } else {
        if(!testing) ide_paste_text(current)
      }
    } else {
      if (nchar(current) != nchar(ch_env$stream$response)) {
        delta <- substr(
          current,
          nchar(ch_env$stream$response) + 1,
          nchar(current)
        )
        if (ui_current_console()) {
          if(!testing) cat(delta)
        } else {
          for (i in 1:nchar(delta)) {
            if(!testing) ide_paste_text(substr(delta, i, i))
          }
        }
      }
    }
  }
  ch_env$stream$response <- current
}


openai_stream_file <- function(endpoint,
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

    openai_request(endpoint, req_body) %>%
      req_stream(
        function(x) {
          ch_env$stream$response <- paste0(
            ch_env$stream$response,
            rawToChar(x),
            collapse = ""
          )
          ch_env$stream$response %>%
            openai_stream_parse(endpoint) %>%
            saveRDS(r_file_stream)
          TRUE
        },
        buffer_kb = 0.05
      )
    ret <- readRDS(r_file_stream)
    saveRDS(ret, r_file_complete)
    file_delete(r_file_stream)
  }
  ret
}

openai_stream_parse <- function(x, endpoint) {
  res <- x %>%
    paste0(collapse = "") %>%
    strsplit("data: ") %>%
    unlist() %>%
    discard(~ .x == "") %>%
    keep(~ substr(.x, (nchar(.x) - 2), nchar(.x)) == "}\n\n") %>%
    map(jsonlite::fromJSON)

  if (length(res) > 0) {
    if (endpoint == "completions") {
      res <- res %>%
        map(~ .x$choices$text) %>%
        reduce(paste0)
    }

    if (endpoint == "chat/completions") {
      res <- res %>%
        map(~ .x$choices$delta$content) %>%
        reduce(paste0)
    }

    if (length(res) > 0) {
      return(res)
    }
  }
}

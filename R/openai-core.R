openai_perform <- function(endpoint, req_body) {
  if (tidychat_debug_get()) {
    req_body
  } else {
    openai_request(endpoint, req_body) %>%
      req_perform() %>%
      resp_body_json()
  }
}

openai_request <- function(endpoint, req_body) {
  "https://api.openai.com/v1/" %>%
    paste0(endpoint) %>%
    request() %>%
    req_auth_bearer_token(openai_token()) %>%
    req_body_json(req_body)
}

openai_token <- function() {
  env_key <- Sys.getenv("OPENAI_API_KEY", unset = NA)

  ret <- NULL
  if (!is.na(env_key)) ret <- env_key
  if (is.null(ret)) ret <- config::get("open-ai-api-key")

  if (is.null(ret)) {
    stop("No token found
       - Add your key to the \"OPENAI_API_KEY\" environment variable
       - or - Add  \"open-ai-api-key\" to a `config` YAML file")
  }

  ret
}

openai_stream_ide <- function(endpoint, req_body) {
  tc_env$stream <- list()
  tc_env$stream$raw <- NULL
  tc_env$stream$response <- NULL

  if (tidychat_debug_get()) {
    req_body
  } else {
    if(ui_current() != "console") ide_paste_text("\n\n")
    openai_request(endpoint, req_body) %>%
      req_stream(
        function(x) {
          tc_env$stream$raw <- paste0(
            tc_env$stream$raw,
            rawToChar(x),
            collapse = ""
          )
          current <- openai_stream_parse(
            x = tc_env$stream$raw,
            endpoint = endpoint
          )
          if (!is.null(current)) {
            if (is.null(tc_env$stream$response)) {
              if(ui_current() == "console") {
                cat(current)
              } else {
                ide_paste_text(current)
              }
            } else {
              if (nchar(current) != nchar(tc_env$stream$response)) {
                delta <- substr(
                  current,
                  nchar(tc_env$stream$response) + 1,
                  nchar(current)
                )
                if(ui_current() == "console") {
                  cat(delta)
                } else {
                  for(i in 1:nchar(delta)) {
                    ide_paste_text(substr(delta, i, i))
                  }
                }
              }
            }
          }
          tc_env$stream$response <- current
          TRUE
        },
        buffer_kb = 0.1
      )
    if(ui_current() != "console") ide_paste_text("\n\n")
    tc_env$stream$response
  }
}

openai_stream_file <- function(endpoint,
                               req_body,
                               r_file_stream,
                               r_file_complete) {
  tc_env$stream <- list()
  tc_env$stream$response <- NULL

  if (tidychat_debug_get()) {
    req_body
  } else {
    tc_env$stream$response <- NULL

    openai_request(endpoint, req_body) %>%
      req_stream(
        function(x) {
          tc_env$stream$response <- paste0(
            tc_env$stream$response,
            rawToChar(x),
            collapse = ""
          )
          ret <- openai_stream_parse(
            x = tc_env$stream$response,
            endpoint = endpoint
          )
          saveRDS(ret, r_file_stream)
          TRUE
        },
        buffer_kb = 0.1
      )
    ret <- readRDS(r_file_stream)
    file_delete(r_file_stream)
    saveRDS(ret, r_file_complete)
    ret
  }
}

openai_stream_parse <- function(x, endpoint) {
  res <- x %>%
    paste0(collapse = "") %>%
    strsplit("data: ") %>%
    unlist() %>%
    purrr::discard(~ .x == "") %>%
    purrr::keep(~ substr(.x, (nchar(.x) - 2), nchar(.x)) == "}\n\n") %>%
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

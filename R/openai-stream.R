openai_stream_ide <- function(endpoint, req_body) {
  if (tidychat_debug_get()) {
    req_body
  } else {
    ide_paste_text("\n\n")
    openai_request(endpoint, req_body) %>%
      req_stream(
        function(x) {
          tidychat_env$stream$raw <- paste0(
            tidychat_env$stream$raw,
            rawToChar(x),
            collapse = ""
          )
          current <- openai_stream_parse(
            x = tidychat_env$stream$raw,
            endpoint = endpoint
          )
          if(!is.null(current)) {
            if(is.null(tidychat_env$stream$response)) {
              ide_paste_text(current)
            } else {
              if(nchar(current) != nchar(tidychat_env$stream$response)) {
                delta <- substr(
                  current,
                  nchar(tidychat_env$stream$response) + 1,
                  nchar(current)
                  )
                ide_paste_text(delta)
              }
            }
          }
          tidychat_env$stream$response <- current
          TRUE
        },
        buffer_kb = 0.1
      )
    ide_paste_text("\n\n")
  }
}

openai_stream_file <- function(endpoint, req_body) {
  if (tidychat_debug_get()) {
    req_body
  } else {
    path <- tidychat_stream_path()

    tidychat_env$stream$response <- NULL

    openai_request(endpoint, req_body) %>%
      req_stream(
        function(x) {
          tidychat_env$stream$response <- paste0(
            tidychat_env$stream$response,
            rawToChar(x),
            collapse = ""
          )
          ret <- openai_stream_parse(
            x = tidychat_env$stream$response,
            endpoint = endpoint
            )
          saveRDS(ret, path)
          TRUE
        },
        buffer_kb = 0.1
      )
    ret <- readRDS(path)
    file_delete(path)
    ret
  }
}

openai_stream_parse <- function(x, endpoint) {
  res <- x %>%
    paste0(collapse = "") %>%
    strsplit("data: ") %>%
    unlist() %>%
    purrr::discard(~ .x == "")  %>%
    purrr::keep(~ substr(.x, (nchar(.x) - 2), nchar(.x)) == "}\n\n") %>%
    map(jsonlite::fromJSON)

  if(length(res) > 0) {

    if(endpoint == "completions") {
      res <- res %>%
        map(~ .x$choices$text) %>%
        reduce(paste0)
    }

    if(endpoint == "chat/completions") {
      res <- res %>%
        map(~ .x$choices$delta$content) %>%
        reduce(paste0)
    }

    if(length(res) > 0) return(res)
  }
}

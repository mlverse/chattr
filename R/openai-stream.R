openai_stream_ide <- function(endpoint, req_body) {
  if (tidychat_debug_get()) {
    req_body
  } else {

    tidychat_env$raw <- NULL
    tidychat_env$stream <- NULL

    ide_paste_text("\n\n")
    openai_request(endpoint, req_body) %>%
      req_stream(
        function(x) {
          tidychat_env$raw <- paste0(
            tidychat_env$raw,
            rawToChar(x),
            collapse = ""
          )
          current <- openai_stream_parse(tidychat_env$raw)

          if(!is.null(current)) {
            if(is.null(tidychat_env$stream)) {
              ide_paste_text(current)
            } else {
              if(nchar(current) != nchar(tidychat_env$stream)) {
                delta <- substr(current, nchar(tidychat_env$stream) + 1, nchar(current))
                ide_paste_text(delta)
              }
            }
          }
          tidychat_env$stream <- current
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

    tidychat_env$response <- NULL

    openai_request(endpoint, req_body) %>%
      req_stream(
        function(x) {
          tidychat_env$response <- paste0(
            tidychat_env$response,
            rawToChar(x),
            collapse = ""
          )
          ret <- openai_stream_parse(tidychat_env$response)
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

openai_stream_parse <- function(x) {
  cx <- paste0(x, collapse = "")
  start <- NULL
  end <- NULL
  resp <- NULL
  for (i in seq_len(nchar(cx))) {
    cr <- substr(cx, i, nchar(cx))
    fn <- regexpr("data: \\{", cr)[[1]]
    if (fn == 1) {
      if (is.null(start)) {
        start <- i
      } else {
        end <- i - 1
        entry <- substr(cx, start + 6, end)
        json <- jsonlite::fromJSON(entry)
        resp <- paste0(resp, json$choices$delta$content, collapse = "")
        start <- i
      }
    }
  }
  resp
}

#' @export
ch_submit.ch_ollama <- function(
    defaults,
    prompt = NULL,
    stream = NULL,
    prompt_build = TRUE,
    preview = FALSE,
    ...) {

  system_msg <- defaults$system_msg
  if (!is.null(system_msg)) {
    system_msg <- list(role = "system", content = defaults$system_msg)
  }
  req_body <- c(
    list(messages = list(list(role = "user", content = prompt), system_msg)),
    model = defaults$model
  )
  ret <- NULL
  req_result <- defaults$path %>%
    request() %>%
    req_body_json(req_body) %>%
    req_perform_stream(
      function(x) {
        char_x <- rawToChar(x)
        list_x <- jsonlite::parse_json(char_x)
        content_x <- list_x$message$content
        if(!is.null(list_x$error)) {
          abort(list_x$error)
        }
        cat(content_x)
        ret <<- paste0(ret, content_x)
        TRUE
      },
      buffer_kb = 0.05, round = "line"
    )
  ret
}

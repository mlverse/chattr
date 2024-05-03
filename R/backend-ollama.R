#' @export
ch_submit.ch_ollama <- function(
    defaults,
    prompt = NULL,
    stream = NULL,
    prompt_build = TRUE,
    preview = FALSE,
    ...) {
  installed_models <- ch_ollama_tags(defaults)
  model <- defaults$model

  if (!model %in% names(installed_models)) {
    cli_alert_warning("The {.emph '{model}'} model is not found.")
    cli_text("Would you like to download it?")
    resp <- menu(c("Yes", "No"))
    if (resp == 1) {
      ch_ollama_pull(model, defaults)
    } else {
      return(invisible())
    }
  }

  system_msg <- defaults$system_msg
  if (!is.null(system_msg)) {
    system_msg <- list(role = "system", content = system_msg)
  }

  messages <- list(
    list(role = "user", content = prompt),
    system_msg
  )

  prompt_add <- defaults$prompt
  if (!is.null(prompt_add) && prompt_build) {
    prompt_add <- list(role = "user", content = prompt_add)
    messages <- c(prompt_add, messages)
  }

  req_body <- c(
    list(messages = messages),
    model = defaults$model
  )

  ollama_chat <- url_parse(defaults$path)
  ollama_chat$path <- "api/chat"

  ret <- NULL
  req_result <- ollama_chat %>%
    url_build() %>%
    request() %>%
    req_body_json(req_body) %>%
    req_perform_stream(
      function(x) {
        char_x <- rawToChar(x)
        list_x <- jsonlite::parse_json(char_x)
        content_x <- list_x$message$content
        if (!is.null(list_x$error)) {
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

ch_ollama_pull <- function(model, defaults) {
  ollama_chat <- url_parse(defaults$path)
  ollama_chat$path <- "api/pull"
  json_curr <- ""
  req_result <- ollama_chat %>%
    url_build() %>%
    request() %>%
    req_body_json(list(name = model)) %>%
    req_perform_stream(
      function(x) {
        char_x <- rawToChar(x)
        json_x <- try(jsonlite::parse_json(char_x), silent = TRUE)
        if (!inherits(json_x, "try-error")) {
          if (json_curr != json_x$status) {
            cat(paste0(json_x$status, "\n"))
            json_curr <<- json_x$status
          }
        } else {
          invisible()
        }
        TRUE
      },
      buffer_kb = 0.05, round = "line"
    )
}

ch_ollama_tags <- function(defaults) {
  ollama_http <- url_parse(defaults$path)
  ollama_http$path <- "/api/tags"
  ollama_tags <- ollama_http %>%
    url_build() %>%
    request() %>%
    req_perform() %>%
    try(silent = TRUE)

  if (inherits(ollama_tags, "try-error")) {
    ret <- NULL
  } else {
    ret <- resp_body_json(ollama_tags)[[1]]
    model_names <- ret %>%
      map(~ unlist(strsplit(.x$model, ":"))[[1]]) %>%
      as.character()
    ret <- set_names(ret, model_names)
  }
  ret
}

#' @export
ch_test.ch_ollama <- function(defaults = NULL) {
  if (ch_debug_get()) {
    prompt <- "TEST"
    out <- "TEST"
  } else {
    prompt <- "Hi!"
    out <- capture.output(chattr(prompt))
  }

  if (is.null(out)) out <- ""

  cli_div(theme = cli_colors())
  cli_h3("Testing chattr")
  print_provider(defaults)

  if (nchar(out) > 0) {
    cli_alert_success("Connection with Ollama cofirmed")
    cli_text("|--Prompt: {.val2 {prompt}}")
    cli_text("|--Response: {.val1 {out}}")
  } else {
    cli_alert_danger("Connection with Ollama failed")
  }
}

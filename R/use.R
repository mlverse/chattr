#' Sets base defaults for specific LLM model
#' @export
ch_use_openai_gpt35 <- function() {
  use_switch("configs", "default.yml")
}

#' @export
#' @rdname ch_use_openai_gpt35
ch_use_openai_davinci <- function() {
  use_switch("configs", "davinci.yml")
}

use_switch <- function(...) {
  ch_env$defaults <- NULL
  ch_env$chat_history <- NULL
  file <- package_file(...)
  walk(
    c("default", "console", "chat", "notebook", "script"),
    ~ {
      ch_defaults(
        type = .x,
        yaml_file = file,
        force = TRUE
      )
    }
  )
  tc <- ch_defaults()
  cli_li("Provider: {tc$provider}")
  cli_li("Model: {tc$model}")
}

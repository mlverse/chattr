#' Sets base defaults for specific LLM model
#' @export
tc_use_openai_gpt35 <- function() {
  use_switch("configs", "default.yml")
}

#' @export
#' @rdname tc_use_openai_gpt35
tc_use_openai_davinci <- function() {
  use_switch("configs", "davinci.yml")
}

#' @export
#' @rdname tc_use_openai_gpt35
tc_use_nomicai_lora <- function() {
  use_switch("configs", "nomicai.yml")
}


use_switch <- function(...) {
  tc_env$defaults <- NULL
  tc_env$chat_history <- NULL
  file <- package_file(...)
  walk(
    c("default", "console", "chat", "notebook", "script"),
    ~ {
      tc_defaults(
        type = .x,
        yaml_file = file,
        force = TRUE
      )
    }
  )
  tc <- tc_defaults()
  cli_li("Provider: {tc$provider}")
  cli_li("Model: {tc$model}")
}

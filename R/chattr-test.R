#' Confirms conectivity to LLM interface
#' @inheritParams ch_submit
#' @export
chattr_test <- function(defaults = ch_defaults()) {
  UseMethod("chattr_test")
}

#' @export
chattr_test.ch_open_ai_chat_completions <- function(defaults = ch_defaults()) {
  chattr_test_open_ai(defaults = defaults)
}

#' @export
chattr_test.ch_open_ai_completions <- function(defaults = ch_defaults()) {
  chattr_test_open_ai(defaults = defaults)
}

chattr_test_open_ai <- function(defaults = ch_defaults()) {
  req <- request("https://api.openai.com/v1/models") %>%
    req_auth_bearer_token(openai_token()) %>%
    req_perform()

  models <- map_chr(resp_body_json(req)$data, ~ .x$id)

  if (req$status_code == 200) {
    cli_alert_success("Connection with OpenAI cofirmed")
  } else {
    cli_alert_danger("Connection with OpenAI failed")
  }

  if (length(models) > 0) {
    cli_alert_success("Access to models confirmed")
  } else {
    cli_alert_danger("Failed to access model")
  }
}

#' Confirms connectivity with model
#' @export
chattr_test <- function() {
  ch_test(defaults = ch_defaults())
}

#' Confirms connectivity with model
#' @inheritParams ch_submit
#' @export
ch_test <- function(defaults = ch_defaults()) {
  UseMethod("ch_test")
}

#' @export
ch_test.ch_provider_open_ai <- function(defaults = ch_defaults()) {
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

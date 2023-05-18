#' Confirms connectivity with model
#' @export
tidychat_test <- function() {
  tc_test(defaults = tc_defaults())
}

#' Confirms connectivity with model
#' @inheritParams tc_submit
#' @export
tc_test <- function(defaults = tc_defaults()) {
  UseMethod("tc_test")
}

#' @export
tc_test.tc_provider_open_ai <- function(defaults = tc_defaults()) {
  req <- request("https://api.openai.com/v1/models") %>%
    req_auth_bearer_token(openai_token()) %>%
    req_perform()

  req_content <- req %>%
    resp_body_json()

  models <- map_chr(req_content$data, ~ .x$id)

  if(req$status_code == 200) {
    cli_alert_success("Connection with OpenAI cofirmed")
  } else {
    cli_alert_danger("Connection with OpenAI failed")
  }

  if(length(models) > 0) {
    cli_alert_success("Access to models confirmed")
  } else {
    cli_alert_success("Failed to access model")
  }
}

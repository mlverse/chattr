openai_get_completion <- function(prompt = NULL,
                                  model = NULL,
                                  ...) {
  if(grepl("gpt", model)) {
    openai_get_chat_completion_text(
      prompt = prompt,
      model = model,
      ... = ...
    )
  } else {
    openai_get_completion(
      prompt = prompt,
      model = model,
      ... = ...
    )
  }
}

openai_get_completion_text <- function(prompt = NULL,
                                       model = "text-davinci-003",
                                       max_tokens = 100,
                                       temperature = 0) {
  if (is.null(prompt)) stop("No prompt provided")
  comp <- openai_start_request("completions") %>%
    req_body_json(list(
      model = model,
      prompt = prompt,
      max_tokens = max_tokens,
      temperature = temperature
    )) %>%
    req_perform()

  resp_body_json(comp)$choices[[1]]$text
}


openai_get_chat_completion_text <- function(prompt = NULL,
                                            model = "gpt-3.5-turbo",
                                            max_tokens = 100,
                                            temperature = 0) {
  req_body <- list(
    model = model,
    max_tokens = max_tokens,
    temperature = temperature,
    messages = list(
      list(
        role = "user",
        content = prompt
      )
    )
  )

  if (is.null(prompt)) stop("No prompt provided")
  comp <- openai_start_request("chat/completions") %>%
    req_body_json(req_body) %>%
    req_perform()

  resp_body_json(comp)$choices[[1]]$message$content
}

openai_start_request <- function(endpoint) {
  request(paste0("https://api.openai.com/v1/", endpoint)) %>%
    req_auth_bearer_token(config::get("key"))
}

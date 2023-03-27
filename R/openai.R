# Functions to integrate with the OpenAI API

openai_get_completion <- function(prompt = NULL,
                                  model = NULL,
                                  ...) {
  if (grepl("gpt", model)) {
    openai_get_chat_completion_text(
      prompt = prompt,
      model = model,
      ... = ...
    )
  } else {
    openai_get_completion_text(
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
  req_body <- list(
    model = model,
    prompt = prompt,
    max_tokens = max_tokens,
    temperature = temperature
  )
  comp <- openai_perform("completions", req_body)
  comp$choices[[1]]$text
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
        role = "system",
        content = "You are a helpful coding assistant, you reply with code, only breif comment when needed"
      ),
      list(
        role = "user",
        content = prompt
      )
    )
  )
  comp <- openai_perform("chat/completions", req_body)
  comp$choices[[1]]$message$content
}

openai_perform <- function(endpoint, req_body) {
  "https://api.openai.com/v1/" %>%
    paste0(endpoint) %>%
    request() %>%
    req_auth_bearer_token(openai_token()) %>%
    req_body_json(req_body) %>%
    req_perform() %>%
    resp_body_json()
}

openai_token <- function() {
  env_key <- Sys.getenv("OPENAI_API_KEY", unset = NA)

  ret <- NULL
  if (!is.na(env_key)) ret <- env_key
  if (is.null(ret)) ret <- config::get("open-ai-api-key")

  if (is.null(ret)) {
    stop("No token found
       - Add your key to the \"OPENAI_API_KEY\" environment variable
       - or - Add  \"open-ai-api-key\" to a `config` YAML file")
  }

  ret
}

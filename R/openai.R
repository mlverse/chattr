# Functions to integrate with the OpenAI API

openai_get_completion <- function(prompt = NULL,
                                  model = NULL,
                                  system_msg = NULL,
                                  model_arguments = NULL) {
  if (grepl("gpt", model)) {
    openai_get_chat_completion_text(
      prompt = prompt,
      model = model,
      system_msg = system_msg,
      model_arguments = model_arguments
    )
  } else {
    openai_get_completion_text(
      prompt = prompt,
      model = model,
      model_arguments = model_arguments
    )
  }
}

openai_get_completion_text <- function(prompt = NULL,
                                       model = "text-davinci-003",
                                       model_arguments = NULL) {
  req_body <- c(
    list(
      model = model,
      prompt = prompt
    ),
    model_arguments
  )

  comp <- openai_perform("completions", req_body)
  comp$choices[[1]]$text
}

openai_get_chat_completion_text <- function(prompt = NULL,
                                            model = "gpt-3.5-turbo",
                                            system_msg = NULL,
                                            model_arguments = NULL) {
  if (!is.null(system_msg)) {
    system_msg <- list(
      role = "system",
      content = system_msg
    )
  }

  req_body <- c(
    list(
      model = model,
      messages = list(
        system_msg,
        list(
          role = "user",
          content = prompt
        )
      )
    ),
    model_arguments
  )

  comp <- openai_perform("chat/completions", req_body)
  comp$choices[[1]]$message$content
}

openai_perform <- function(endpoint, req_body) {
  if (tidychat_debug_get()) {
    print(req_body)
  } else {
    "https://api.openai.com/v1/" %>%
      paste0(endpoint) %>%
      request() %>%
      req_auth_bearer_token(openai_token()) %>%
      req_body_json(req_body) %>%
      req_perform() %>%
      resp_body_json()
  }
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

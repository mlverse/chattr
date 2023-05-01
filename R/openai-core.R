openai_get_completion_text <- function(prompt = NULL,
                                       model = "text-davinci-003",
                                       defaults = NULL) {
  req_body <- c(
    list(
      model = model,
      prompt = prompt
    ),
    defaults$model_arguments
  )

  ret <- openai_switch(
    endpoint = "completions",
    req_body = req_body,
    defaults = defaults
    )

  if(inherits(ret, "list")) {
    ret <- ret$choices[[1]]$text
  }

  ret
}

openai_get_chat_completion_text <- function(prompt = NULL,
                                            model = "gpt-3.5-turbo",
                                            defaults = NULL) {
  req_body <- c(
    list(
      model = model,
      messages = prompt
    ),
    defaults$model_arguments
  )

  ret <- openai_switch(
    endpoint = "chat/completions",
    req_body = req_body,
    defaults = defaults
    )

  if(inherits(ret, "list")) {
    ret <- ret$choices[[1]]$message$content
  }

  ret
}

openai_switch <- function(endpoint, req_body, defaults) {
  ret <- NULL
  stream <- defaults$model_arguments$stream %||% FALSE
  if (stream) {
    if(defaults$type == "chat") {
      ret <- openai_stream_file(endpoint, req_body)
    } else {
      openai_stream_ide(endpoint, req_body)
    }
  } else {
    ret <- openai_perform(endpoint, req_body)
  }
  ret
}

openai_perform <- function(endpoint, req_body) {
  if (tidychat_debug_get()) {
    req_body
  } else {
    openai_request(endpoint, req_body) %>%
      req_perform() %>%
      resp_body_json()
  }
}

openai_request <- function(endpoint, req_body) {
  "https://api.openai.com/v1/" %>%
    paste0(endpoint) %>%
    request() %>%
    req_auth_bearer_token(openai_token()) %>%
    req_body_json(req_body)
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

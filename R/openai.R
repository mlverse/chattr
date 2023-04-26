#' @export
tidychat_submit.tc_provider_open_ai <- function(defaults,
                                                prompt = NULL,
                                                add_to_history = TRUE,
                                                prompt_build = TRUE,
                                                preview = FALSE) {
  if (prompt_build) {
    full_prompt <- build_prompt(
      prompt = prompt,
      defaults = defaults
    )
  } else {
    full_prompt <- list(
      full = prompt,
      prompt = prompt
    )
  }

  if (!preview) {
    comp_text <- openai_get_completion(
      defaults,
      prompt = full_prompt$full
    )
    text_output <- paste0("\n\n", comp_text, "\n\n")

    if (add_to_history) {
      chat_entry <- list(
        list(role = "user", content = full_prompt$prompt),
        list(role = "assistant", content = comp_text)
      )
      tidychat_history_append(chat_entry)
    }
  } else {
    text_output <- full_prompt$full
  }

  text_output
}

openai_get_completion <- function(defaults,
                                  prompt = NULL,
                                  model_arguments = NULL) {
  UseMethod("openai_get_completion")
}

openai_get_completion.tc_model_gpt_3.5_turbo <- function(defaults,
                                                         prompt = NULL,
                                                         model_arguments = NULL) {
  openai_get_chat_completion_text(
    prompt = prompt,
    model = "gpt-3.5-turbo",
    model_arguments = defaults$model_arguments
  )
}

openai_get_completion.tc_model_davinci_3 <- function(defaults,
                                                     prompt = NULL,
                                                     model_arguments = NULL) {
  openai_get_completion_text(
    prompt = prompt,
    model = "text-davinci-003",
    model_arguments = defaults$model_arguments
  )
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
                                            model_arguments = NULL) {
  req_body <- c(
    list(
      model = model,
      messages = prompt
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

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
      defaults = defaults,
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
                                  prompt = NULL) {
  UseMethod("openai_get_completion")
}

openai_get_completion.tc_model_gpt_3.5_turbo <- function(defaults,
                                                         prompt = NULL) {
  openai_get_chat_completion_text(
    prompt = prompt,
    model = "gpt-3.5-turbo",
    model_arguments = defaults$model_arguments
  )
}

openai_get_completion.tc_model_davinci_3 <- function(defaults,
                                                     prompt = NULL) {
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
                                            model_arguments = NULL
                                            ) {
  req_body <- c(
    list(
      model = model,
      messages = prompt
    ),
    model_arguments
  )

  if(model_arguments$stream) {
    ret <- NULL
    openai_stream("chat/completions", req_body)
  } else {
    comp <- openai_perform("chat/completions", req_body)
    ret <- comp$choices[[1]]$message$content
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

openai_stream <- function(endpoint, req_body) {
  if (tidychat_debug_get()) {
    req_body
  } else {
    path <- tidychat_stream_path()

    openai_request(endpoint, req_body) %>%
      req_stream(
        function(x){
          if(!file.exists(path)) {
            writeLines("", path)
          } else {
            con <- file(path, "a")
            writeLines(rawToChar(x), con)
            close(con)
          }
          TRUE
        },
        buffer_kb = 0.1
      )
    fs::file_delete(path)
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


open_ai_parse <- function(x) {
  cx <- paste0(x, collapse = "")
  start <- NULL
  end <- NULL
  resp <- NULL
  for(i in seq_len(nchar(cx))) {
    cr <- substr(cx, i, nchar(cx))
    fn <- regexpr("data: \\{", cr)[[1]]
    if(fn == 1) {
      if(is.null(start)) {
        start <- i
      } else {
        end <- i - 1
        entry <- substr(cx, start + 6, end)
        json <- jsonlite::fromJSON(entry)
        resp <- paste0(resp, json$choices$delta$content, collapse = "")
        start <- i
      }
    }
  }
  resp
}

tidychat_submit.tc_model_lora_quantized <- function(defaults,
                                                    prompt = NULL,
                                                    prompt_build = TRUE,
                                                    preview = FALSE,
                                                    ...) {
  prompt <- build_null_prompt(prompt)

  if(prompt_build) {
    header <- paste0(defaults$prompt, collapse = " \\ ")
    prompt <- paste0(header, "\\", prompt)
  }

  if(preview) {
    ret <- prompt
  } else {
    if(defaults$type == "chat") {
      nomicai_chat_stream(prompt)
    } else {
      ret <- nomicai_chat(prompt)
    }
  }

  if(is.null(ret)) return(invisible())

  ret
}


nomicai_env <- new.env()

tidychat_use_nomicai_lora <- function() {
  walk(
    c("default", "console", "chat", "markdown"),
    ~ {
      tidychat_defaults(
        type = .x,
        yaml_file = package_file("configs", "nomicai.yml"),
        force = TRUE
      )
    }
  )
}

nomicai_chat <- function(prompt = NULL, stream = TRUE) {
  gpt4all_start()
  if (!is.null(terminal_get())) {
    td <- terminal_contents()
    terminal_send(prompt)
    if(stream) {
      gpt4all_stream(length(td) + 1)
    } else {
      gpt4all_wait_last()
    }
  } else {
    stop("Model does not seem to be running in terminal yet")
  }
}

gpt4all_start <- function() {
  if(is.null(terminal_get())) {
    gpt4all_location <- fs::path_expand("~/gpt4all/chat")
    terminal_start()
    Sys.sleep(1)
    terminal_send(paste0("cd ", gpt4all_location))
    Sys.sleep(1)
    terminal_send(paste0("./", gpt4all_exec(), " --temp 0.01"))
    Sys.sleep(6)
  }
}

gpt4all_exec <- function() {
  si <- Sys.info()
  sysname <- si[names(si) == "sysname"]
  machine <- si[names(si) == "machine"]
  exec_name <- NULL
  if (sysname == "Darwin" & machine == "arm64") {
    exec_name <- "gpt4all-lora-quantized-OSX-m1"
  }
  exec_name
}

terminal_get <- function() {
  nomicai_env$terminal_id
}

terminal_set <- function(terminal_id) {
  nomicai_env$terminal_id <- terminal_id
}

terminal_start <- function() {
  if(is.null(terminal_get())) {
    nomicai_env$terminal_id <- rstudioapi::terminalCreate()
  }
  terminal_get()
}

terminal_send <- function(x) {
  x <- paste0(x, "\n")
  rstudioapi::terminalSend(terminal_get(), x)
}

terminal_contents <- function() {
  cb <- rstudioapi::terminalBuffer(terminal_get())

  cb_start <- which(cb == " - If you want to submit another line, end your input in '\\'.")

  cb[(cb_start + 2):length(cb)]
}

terminal_end <- function() {
  rstudioapi::terminalKill(terminal_get())
  nomicai_env$terminal_id <- NULL
}

gpt4all_last_output <- function() {
  tc <- terminal_contents()
  prompts <- which(substr(tc, 1, 2) == "> ")
  start <- prompts[length(prompts) - 1] + 1
  end <- prompts[length(prompts)] - 1
  tc[start:end]
}

gpt4all_current_output <- function() {
  tc <- terminal_contents()
  prompts <- which(substr(tc, 1, 2) == "> ")
  curr <- prompts[length(prompts) - 1]
  tc[curr]
}

last_line_prompt <- function() {
  tc <- terminal_contents()
  prompts <- which(substr(tc, 1, 2) == "> ")
  last_prompt <- max(prompts)
  length(tc) == last_prompt
}

gpt4all_wait_last <- function(timeout = 100) {
  for (i in 1:timeout) {
    Sys.sleep(1)
    if (last_line_prompt()) {
      return(gpt4all_last_output())
    }
  }
}

gpt4all_stream <- function(start_line = 1, timeout = 100) {
  contents <- ""
  Sys.sleep(1)
  for (i in 1:100) {
    Sys.sleep(0.1)
    if(!last_line_prompt()) {
      tc <- terminal_contents()
      tc <- paste0(tc[start_line:length(tc)], collapse = "\n")
      if(tc != contents) {
        delta <- substr(tc, nchar(contents) + 1, nchar(tc))
        cat(delta)
        contents <- tc
      }
    } else {
      break
    }
  }
}

nomicai_chat_stream <- function(prompt = NULL, stream = TRUE) {
  gpt4all_start()
  if (!is.null(terminal_get())) {
    td <- terminal_contents()
    terminal_send(prompt)
  } else {
    stop("Model does not seem to be running in terminal yet")
  }
}

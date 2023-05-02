nomicai_env <- new.env()

tidychat_use_nomicai_gpt3 <- function() {
  tidychat_defaults(
    yaml_file = system.file("configs/nomic.yml", package = "tidychat")
  )
  gpt4all_start()
}

nomicai_chat <- function(prompt = NULL) {
  if (!is.null(nomicai_env$terminal_id)) {
    terminal_send(prompt)
    gpt4all_wait_last()
  } else {
    stop("Model does not seem to be running in terminal yet")
  }
}

gpt4all_start <- function() {
  gpt4all_location <- fs::path_expand("~/gpt4all/chat")
  terminal_start()
  Sys.sleep(1)
  terminal_send(paste0("cd ", gpt4all_location))
  Sys.sleep(1)
  terminal_send(paste0("./", gpt4all_exec(), " --temp 0.01"))
  Sys.sleep(6)
  nomicai_chat("* Use tidyverse packages: readr, ggplot2, dplyr, tidyr")
  nomicai_chat("* Avoid additional comments unless necessary, expecting code only")
  nomicai_chat("* Return all code responses inside RMarkdown code chunks")
  Sys.sleep(1)
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

terminal_start <- function() {
  nomicai_env$terminal_id <- rstudioapi::terminalCreate()
}

terminal_send <- function(x) {
  x <- paste0(x, "\n")
  rstudioapi::terminalSend(nomicai_env$terminal_id, x)
}

terminal_contents <- function() {
  cb <- rstudioapi::terminalBuffer(nomicai_env$terminal_id)

  cb_start <- which(cb == " - If you want to submit another line, end your input in '\\'.")

  cb[(cb_start + 2):length(cb)]
}

terminal_end <- function() {
  rstudioapi::terminalKill(nomicai_env$terminal_id)
}

gpt4all_last_output <- function() {
  tc <- terminal_contents()
  prompts <- which(substr(tc, 1, 2) == "> ")
  start <- prompts[length(prompts) - 1] + 1
  end <- prompts[length(prompts)] - 1
  tc[start:end]
}

last_line_prompt <- function() {
  tc <- terminal_contents()
  prompts <- which(substr(tc, 1, 2) == "> ")
  last_prompt <- max(prompts)
  length(tc) == last_prompt
}

gpt4all_wait_last <- function(timeout = 100) {
  for (i in 1:100) {
    Sys.sleep(1)
    if (last_line_prompt()) {
      return(gpt4all_last_output())
    }
  }
}

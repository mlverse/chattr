tidychat_use_nomicai_gpt3 <- function() {
  gpt_location <- fs::path_expand("~/gpt4all/chat")
  terminal_start()
  Sys.sleep(1)
  terminal_send(paste0("cd ", gpt_location))
  Sys.sleep(1)
  terminal_send(paste0("./", gpt_exec()))
}

nomicai_chat <- function(prompt = NULL) {
  if(!is.null(tidychat_env$terminal_id)) {
    terminal_send(prompt)
    gpt_wait_last()
  } else {
    stop("Model does not seem to be running in terminal yet")
  }
}

gpt_exec <- function() {

  si <- Sys.info()
  sysname <- si[names(si) == "sysname"]
  machine <- si[names(si) == "machine"]
  exec_name <- NULL
  if(sysname == "Darwin" & machine == "arm64") {
    exec_name <- "gpt4all-lora-quantized-OSX-m1"
  }
  exec_name
}

terminal_start <- function() {
  tidychat_env$terminal_id <- rstudioapi::terminalCreate()
}

terminal_send<- function(x) {
  x <- paste0(x, "\n")
  rstudioapi::terminalSend(tidychat_env$terminal_id, x)
}

terminal_contents <- function() {
  cb <- rstudioapi::terminalBuffer(tidychat_env$terminal_id)

  cb_start <- which(cb == " - If you want to submit another line, end your input in '\\'." )

  cb[(cb_start+2):length(cb)]
}

terminal_end <- function() {
  rstudioapi::terminalKill(tidychat_env$terminal_id)
}

gpt_last_output <- function() {
  tc <- terminal_contents()
  is_prompt <- substr(tc, 1, 2) == "> "
  responses <- tc[!is_prompt]
  responses[length(responses)]
}

last_line_prompt <- function() {
  tc <- terminal_contents()
  prompts <- which(substr(tc, 1, 2) == "> ")
  last_prompt <- max(prompts)
  length(tc) == last_prompt
}

gpt_wait_last <- function(timeout = 100) {
  for(i in 1:100) {
    Sys.sleep(1)
    if(last_line_prompt()) return(gpt_last_output())
  }
}

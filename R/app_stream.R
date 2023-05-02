tidychat_app_stream <- function(defaults) {
  UseMethod("tidychat_app_stream")
}

tidychat_app_stream.tc_provider_open_ai <- function(defaults) {
  td <- tidychat_stream_path()
  if (file.exists(td)) {
    markdown(readRDS(td))
    }
}

tidychat_app_stream.tc_provider_nomic_ai <- function(defaults) {
  if(!is.null(terminal_get())) {
    tc <- terminal_contents()
    more_thans <- which(substr(tc, 1, 1) == ">")
    more_than <- more_thans[length(more_thans)]
    body <- tc[(more_than + 1):length(tc)]
    ret <- paste0(body, collapse = "\n")
    if(more_than < length(tc)) {
      markdown(ret)
    } else {
      saveRDS(ret, tidychat_stream_output())
    }
  }
}

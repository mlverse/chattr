#' Method to easily integrate to new LLM's
#' @param defaults Defaults object, generally puled from `tidychat_defaults()`
#' @param prompt The prompt to send to the LLM
#' @param prompt_build Include the context and additional prompt as part of the
#' request
#' @param preview Primarily used for debugging. It indicates if it should send
#' the prompt to the LLM (FALSE), or if it should print out the resulting
#' prompt (TRUE)
#' @param r_file_stream (Optional) Path to save the output of the current stream
#' from the LLM
#' @param r_file_complete (Optional) Path to save the completed output of the
#' stream, or response from the LLM
#' @param ... Optional arguments; currently unused.
#' @keywords internal
#' @export
tidychat_submit <- function(defaults,
                            prompt = NULL,
                            prompt_build = TRUE,
                            preview = FALSE,
                            r_file_stream = NULL,
                            r_file_complete = NULL,
                            ...) {
  UseMethod("tidychat_submit")
}

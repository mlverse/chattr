#' Method to easily integrate to new LLM's
#' @param defaults Defaults object, generally puled from `tidychat_defaults()`
#' @param prompt The prompt to send to the LLM
#' @param prompt_build Include the context and additional prompt as part of the
#' request
#' @param preview Primarily used for debugging. It indicates if it should send
#' the prompt to the LLM (FALSE), or if it should print out the resulting
#' prompt (TRUE)
#' @param ... Optional arguments; currently unused.
#' @keywords internal
#' @export
tidychat_submit <- function(defaults,
                            prompt = NULL,
                            prompt_build = TRUE,
                            preview = FALSE,
                            ...) {
  UseMethod("tidychat_submit")
}

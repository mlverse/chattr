#' Method to easily integrate to new LLM API's
#' @param defaults Defaults object, generally puled from `chattr_defaults()`
#' @param prompt The prompt to send to the LLM
#' @param stream To output the response from the LLM as it happens, or wait until
#' the response is complete. Defaults to TRUE.
#' @param prompt_build Include the context and additional prompt as part of the
#' request
#' @param preview Primarily used for debugging. It indicates if it should send
#' the prompt to the LLM (FALSE), or if it should print out the resulting
#' prompt (TRUE)
#' @param ... Optional arguments; currently unused.
#' @keywords internal
#' @details Use this function to integrate your own LLM API. It has a few
#' requirements to get it to work properly:
#' * The output of the function needs to be the parsed response from the LLM
#' * For those that support streaming, make sure to use the `cat()` function to
#' output the response of the LLM API as it is happening.
#' * If `preview` is set to TRUE, do not send to the LLM API. Simply return the
#' resulting prompt.
#'
#' The `defaults` argument controls which method to use. You can use the
#' `chattr_defaults()` function, and set the provider. The `provider` value
#' is what creates the R class name. It will pre-pend `cl_` to the class name.
#' See the examples for more clarity.
#' @returns The output from the model currently in use.
#' @examples
#' \dontrun{
#' library(chattr)
#' ch_submit.ch_my_llm <- function(defaults,
#'                                 prompt = NULL,
#'                                 stream = NULL,
#'                                 prompt_build = TRUE,
#'                                 preview = FALSE,
#'                                 ...) {
#'   # Use `prompt_build` to append the prompts you with to append
#'   if (prompt_build) prompt <- paste0("Use the tidyverse\n", prompt)
#'   # If `preview` is true, return the resulting prompt back
#'   if (preview) {
#'     return(prompt)
#'   }
#'   llm_response <- paste0("You said this: \n", prompt)
#'   if (stream) {
#'     cat("streaming:\n")
#'     for (i in seq_len(nchar(llm_response))) {
#'       # If `stream` is true, make sure to `cat()` the current output
#'       cat(substr(llm_response, i, i))
#'       Sys.sleep(0.1)
#'     }
#'   }
#'   # Make sure to return the entire output from the LLM at the end
#'   llm_response
#' }
#'
#' chattr_defaults("console", provider = "my llm")
#' chattr("hello")
#' chattr("hello", stream = FALSE)
#' chattr("hello", prompt_build = FALSE)
#' chattr("hello", preview = TRUE)
#' }
#' @export
ch_submit <- function(defaults,
                      prompt = NULL,
                      stream = NULL,
                      prompt_build = TRUE,
                      preview = FALSE,
                      ...) {
  ui_validate(defaults$type)
  UseMethod("ch_submit")
}

# Model selection, prompt building, and weather to include output from the
# context.R functions

tidychat_env <- new.env()

#' @export
tidychat_defaults <- function(prompt = NULL,
                              include_data_files = NULL,
                              include_data_frames = NULL,
                              include_doc_contents = NULL,
                              provider = NULL,
                              model = NULL) {
  td <- tidychat_get_defaults()

  if (is.null(model) & is.null(td$model)) {
    tidychat_use_openai_35_turbo()
  } else {
    tidychat_set_defaults(
      prompt = prompt,
      include_data_files = include_data_files,
      include_data_frames = include_data_frames,
      include_doc_contents = include_doc_contents,
      provider = provider,
      model = model
    )
  }

  tidychat_get_defaults()
}

tidychat_get_defaults <- function() {
  tidychat_env$model_defaults
}

tidychat_set_defaults <- function(prompt = NULL,
                                  include_data_files = NULL,
                                  include_data_frames = NULL,
                                  include_doc_contents = NULL,
                                  provider = NULL,
                                  model = NULL) {
  td <- tidychat_get_defaults()

  tidychat_env$model_defaults <- list(
    prompt = prompt %||% td$prompt,
    include_data_files = include_data_files %||% td$include_data_files,
    include_data_frames = include_data_frames %||% td$include_data_frames,
    include_doc_contents = include_doc_contents %||% td$include_doc_contents,
    provider = provider %||% td$provider,
    model = model %||% td$model
  )
}

#' @export
tidychat_use_openai_35_turbo <- function() {
  tidychat_set_defaults(
    prompt = c(
      "Use tidyverse, readr, ggplot2, dplyr, tidyr",
      "For models, use tidymodels packages: recipes, parsnip, yardstick, workflows",
      "Expecting only code, avoid comments unless requested by user"
    ),
    include_data_files = TRUE,
    include_data_frames = TRUE,
    include_doc_contents = TRUE,
    provider = "openai",
    model = "gpt-3.5-turbo"
  )
}

#' @export
tidychat_use_openai_davinci_3 <- function() {
  tidychat_set_defaults(
    prompt = c(
      "Use tidyverse, readr, ggplot2, dplyr, tidyr",
      "Expecting only code, avoid comments unless requested by user"
    ),
    include_data_files = TRUE,
    include_data_frames = TRUE,
    include_doc_contents = TRUE,
    provider = "openai",
    model = "text-davinci-003"
  )
}

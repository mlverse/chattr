# Model selection, prompt building, and weather to include output from the
# context.R functions

tidychat_env <- new.env()

#' @export
tidychat_defaults <- function(prompt = NULL,
                              include_data_files = NULL,
                              include_data_frames = NULL,
                              include_doc_contents = NULL,
                              provider = NULL,
                              model = NULL,
                              system_msg = NULL,
                              yaml_file = "config.yml"
                              ) {
  td <- tidychat_get_defaults()
  yaml_defaults <- NULL

  if (is.null(model) & is.null(td$model)) {

    if(!is.null(yaml_file) & !file.exists(yaml_file)) {
      yaml_file <- system.file("configs/gpt3.5.yml", package = "tidychat")
    }

    yaml_defaults <- config::get("tidychat", file = yaml_file)

    if(!is.null(yaml_defaults)) {
      prompt <- yaml_defaults$prompt
      if(length(prompt) > 0) prompt <- strsplit(prompt, split = "\n")[[1]]
      tidychat_set_defaults(
        prompt = prompt,
        include_data_files = yaml_defaults$include_data_files,
        include_data_frames = yaml_defaults$include_data_frames,
        include_doc_contents = yaml_defaults$include_doc_contents,
        provider = yaml_defaults$provider,
        model = yaml_defaults$model,
        system_msg = yaml_defaults$system_msg
      )
    }

  } else {
    tidychat_set_defaults(
      prompt = prompt,
      include_data_files = include_data_files,
      include_data_frames = include_data_frames,
      include_doc_contents = include_doc_contents,
      provider = provider,
      model = model,
      system_msg = system_msg
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
                                  model = NULL,
                                  system_msg = NULL) {
  td <- tidychat_get_defaults()

  tidychat_env$model_defaults <- list(
    prompt = prompt %||% td$prompt,
    include_data_files = include_data_files %||% td$include_data_files,
    include_data_frames = include_data_frames %||% td$include_data_frames,
    include_doc_contents = include_doc_contents %||% td$include_doc_contents,
    provider = provider %||% td$provider,
    model = model %||% td$model,
    system_msg = system_msg %||% td$system_msg
  )
}

#' @export
tidychat_use_openai_35_turbo <- function() {
  tidychat_set_defaults(
    prompt = c(
      "Prioritize the content from 'Tidy Modeling with R' (https://www.tmwr.org/), and 'R for Data Science' (https://r4ds.had.co.nz/)",
      "Use tidyverse, readr, ggplot2, dplyr, tidyr",
      "skimr and janitor can also be used if needed",
      "For models, use tidymodels packages: recipes, parsnip, yardstick, workflows, broom",
      "For workflow models, prefer using augment() instead of predict()",
      "Expecting only code, avoid comments unless requested by user"
    ),
    include_data_files = TRUE,
    include_data_frames = TRUE,
    include_doc_contents = TRUE,
    provider = "openai",
    model = "gpt-3.5-turbo-0301",
    system_msg = "You are a helpful coding assistant, you reply with code, only brief comments when needed"
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

# Model selection, prompt building, and weather to include output from the
# context.R functions

tidychat_env <- new.env()

#' Default arguments to use when making requests to the LLM
#' @details The idea is that because we will use addin shortcut to execute the
#' request, all of the other arguments can be controlled via this function. By
#' default, it will try to load defaults from a `config` YAML file, if none are
#' found, then the defaults for GPT 3.5 will be used. The defaults can be modified
#' by calling this function, even after the interactive session has started.
#' @export
#' @param include_data_files Send the list of data files found in the working
#' directory? Defaults to NULL
#' @param include_data_frames Send the list of data.frames currently in the R
#' environment? Defaults to NULL
#' @param include_doc_contents Send the current code in the document
#' @param provider The name of the provider of the LLM. Today, only "openai" is
#' is available
#' @param model The name of the model to use, based on the provider
#' @param system_msg For GPT 3.5 or above, the system message to send as part of
#' the request
#' @param yaml_file The path to a valid `config` YAML file that contains the
#' defaults to use in a session
#' @param model_arguments Additional arguments to pass to the model as part of the
#' request, it requires a list. Examples of arguments: temperature, top_p,
#' max_tokens
#' @inheritParams tidy_chat
tidychat_defaults <- function(prompt = NULL,
                              include_data_files = NULL,
                              include_data_frames = NULL,
                              include_doc_contents = NULL,
                              provider = NULL,
                              model = NULL,
                              system_msg = NULL,
                              yaml_file = "config.yml",
                              model_arguments = NULL) {
  td <- tidychat_get_defaults()
  yaml_defaults <- NULL

  if (is.null(td$provider)) {
    if (!is.null(yaml_file) & !file.exists(yaml_file)) {
      yaml_file <- system.file("configs/gpt3.5.yml", package = "tidychat")
    }

    yaml_defaults <- config::get("tidychat", file = yaml_file)

    if (!is.null(yaml_defaults)) {
      prompt <- yaml_defaults$prompt
      if (length(prompt) > 0) prompt <- strsplit(prompt, split = "\n")[[1]]
      tidychat_set_defaults(
        prompt = prompt,
        include_data_files = yaml_defaults$include_data_files,
        include_data_frames = yaml_defaults$include_data_frames,
        include_doc_contents = yaml_defaults$include_doc_contents,
        provider = yaml_defaults$provider,
        model = yaml_defaults$model,
        system_msg = yaml_defaults$system_msg,
        model_arguments = yaml_defaults$model_arguments
      )
    }
  }

  tidychat_set_defaults(
    prompt = prompt,
    include_data_files = include_data_files,
    include_data_frames = include_data_frames,
    include_doc_contents = include_doc_contents,
    provider = provider,
    model = model,
    system_msg = system_msg,
    model_arguments = model_arguments
  )

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
                                  system_msg = NULL,
                                  model_arguments = NULL) {
  td <- tidychat_get_defaults()

  tidychat_env$model_defaults <- list(
    prompt = prompt %||% td$prompt,
    include_data_files = include_data_files %||% td$include_data_files,
    include_data_frames = include_data_frames %||% td$include_data_frames,
    include_doc_contents = include_doc_contents %||% td$include_doc_contents,
    provider = provider %||% td$provider,
    model = model %||% td$model,
    system_msg = system_msg %||% td$system_msg,
    model_arguments = model_arguments %||% td$model_arguments
  )
}

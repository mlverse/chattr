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
                              yaml_file = "config.yml",
                              model_arguments = NULL
                              ) {
  td <- tidychat_get_defaults()
  yaml_defaults <- NULL

  if (is.null(model) & is.null(td$model)) {

    if(!is.null(yaml_file) & !file.exists(yaml_file)) {
      yaml_file <- system.file("configs/gpt3.5.yml", package = "tidychat")
    }

    yaml_defaults <- config::get("tidychat", file = yaml_file)

    print(paste0("Defaults source: ", yaml_file))

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
        system_msg = yaml_defaults$system_msg,
        model_arguments = yaml_defaults$model_arguments
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
      system_msg = system_msg,
      model_arguments = model_arguments
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
                                  system_msg = NULL,
                                  model_arguments = NULL
                                  ) {
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

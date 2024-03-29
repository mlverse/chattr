ch_gh_token <- function(defaults = NULL, fail = TRUE) {
  ret <- NULL
  if (ch_debug_get()) {
    return("")
  }

  hosts_path <- defaults$hosts_path

  if (is.null(hosts_path)) {
    if (os_win()) {
      possible_path <- path(Sys.getenv("localappdata"), "github-copilot")
    } else {
      possible_path <- "~/.config/github-copilot"
    }
    if (dir_exists(possible_path)) {
      hosts_path <- possible_path
    }
  }

  token_url <- defaults$token_url
  if (is.null(hosts_path) && fail) {
    abort(
      c(
        "There is no default for the RStudio GitHub Copilot configuration folder",
        "Please add a 'hosts_path' to your YAML file, or to chattr_defaults() "
      )
    )
  }
  if (is.null(token_url) && fail) {
    abort(
      c(
        "There is no default GH Copilot token URL",
        "Please add a 'token_url' to your YAML file, or to chattr_defaults() "
      )
    )
  }
  if(is.null(hosts_path)) {
    return(NULL)
  }
  gh_path <- path_expand(hosts_path)
  if (dir_exists(gh_path)) {
    hosts <- jsonlite::read_json(path(gh_path, "hosts.json"))
    oauth_token <- hosts[[1]]$oauth_token
    x <- try({
      request(token_url) %>%
        req_auth_bearer_token(oauth_token) %>%
        req_perform()
      },
      silent = TRUE
    )
    if(inherits(x, "try-error")) {
      if(fail) {
        abort(x)
      } else {
        return(NULL)
      }
    }
    x_json <- resp_body_json(x)
    ret <- x_json$token
  } else {
    if (fail) {
      abort("Please setup GitHub Copilot for RStudio first")
    }
  }
  ret
}

ch_openai_token <- function(defaults, fail = TRUE) {
  if (ch_debug_get()) {
    return("")
  }
  env_key <- Sys.getenv("OPENAI_API_KEY", unset = NA)
  ret <- NULL
  if (!is.na(env_key)) {
    ret <- env_key
  }
  if (is.null(ret) && file_exists(Sys.getenv("R_CONFIG_FILE", "config.yml"))) {
    ret <- config::get("openai-api-key")
  }
  if (is.null(ret) && fail) {
    abort(
      "No token found
    - Add your key to the \"OPENAI_API_KEY\" environment variable
    - or - Add  \"openai-api-key\" to a `config` YAML file"
    )
  }
  ret
}

ch_openai_error <- function(x) {
  if (is.null(x)) {
    return(invisible())
  }
  if (length(x) > 1) {
    return(invisible())
  }
  if (substr(x, 1, 9) == "{{error}}") {
    error_msg <- paste0(
      "Error from OpenAI\n",
      substr(x, 10, nchar(x))
    )
    abort(error_msg)
  }
  invisible()
}

ch_openai_parse <- function(x, defaults) {
  res <- x %>%
    paste0(collapse = "") %>%
    strsplit("data: ") %>%
    unlist() %>%
    discard(~ .x == "") %>%
    keep(~ substr(.x, (nchar(.x) - 2), nchar(.x)) == "}\n\n") %>%
    map(jsonlite::fromJSON)

  out <- NULL
  if (length(res) > 0) {
    content <- res %>%
      map(~ {
        content <- .x$choices$delta$content
        if (is_na(content)) content <- ""
        content
      }) %>%
      reduce(paste0)

    if (length(content) > 0) {
      out <- content
    }
  } else {
    json_res <- try(jsonlite::fromJSON(x), silent = TRUE)
    if (!inherits(json_res, "try-error")) {
      if ("error" %in% names(json_res)) {
        json_error <- json_res$error
        out <- paste0(
          "{{error}}Type:",
          json_error$type,
          "\nMessage: ",
          json_error$message
        )
      }
    }
  }
  out
}

ch_openai_is_copilot <- function(defaults) {
  grepl("copilot", tolower(defaults$provider))
}

#' @export
app_init_message.cl_openai <- function(defaults) {
  print_provider(defaults)
  if (defaults$max_data_files > 0) {
    cli_alert_warning(
      paste0(
        "A list of the top {defaults$max_data_files} files will ",
        "be sent externally to OpenAI with every request\n",
        "To avoid this, set the number of files to be sent to 0 ",
        "using {.run chattr::chattr_defaults(max_data_files = 0)}"
      )
    )
  }

  if (defaults$max_data_frames > 0) {
    cli_alert_warning(
      paste0(
        "A list of the top {defaults$max_data_frames} data.frames ",
        "currently in your R session will be sent externally to ",
        "OpenAI with every request\n To avoid this, set the number ",
        "of data.frames to be sent to 0 using ",
        "{.run chattr::chattr_defaults(max_data_frames = 0)}"
      )
    )
  }
}

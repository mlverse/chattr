#' Starts a Shiny app interface to the LLM
#' @param viewer Specifies where the Shiny app is going to display
#' @param as_job App runs as an RStudio IDE Job. Defaults to FALSE. If set to
#' TRUE, the Shiny app will not be able to transfer the code blocks directly to
#' the document, or console, in the IDE.
#' @param as_job_port Port to use for the Shiny app. Applicable only if `as_job`
#' is set to TRUE.
#' @param as_job_host Host IP to use for the Shiny app. Applicable only if
#'  `as_job` is set to TRUE.
#' @returns A chat interface inside the 'RStudio' IDE
#' @export
chattr_app <- function(viewer = c("viewer", "dialog"),
                       as_job = getOption("chattr.as_job", FALSE),
                       as_job_port = getOption("shiny.port", 7788),
                       as_job_host = getOption("shiny.host", "127.0.0.1")) {
  td <- chattr_defaults(type = "chat")
  show_init <- TRUE
  if (interactive() && is.null(td$provider)) {
    chattr_use()
    td <- chattr_defaults(type = "chat")
    show_init <- FALSE
  }
  if (viewer[1] == "dialog") {
    viewer <- dialogViewer(
      dialogName = glue("chattr - {td$provider} - {td$model}"),
      width = 800
    )
  } else {
    viewer <- paneViewer()
  }
  if (show_init) {
    app_init_message(td)
  }
  if (!as_job) {
    app <- app_interactive(as_job = as_job)
    if (ide_is_rstudio()) {
      runGadget(app$ui, app$server, viewer = viewer)
    } else {
      shinyApp(app$ui, app$server)
    }
  } else {
    run_file <- tempfile()
    defaults_file <- path(
      tempdir(),
      paste0("chat_", paste0(floor(stats::runif(10, 0, 10)), collapse = "")),
      ext = "yml"
    )
    chattr_defaults_save(defaults_file)
    app_code <- c(
      paste0(
        "Sys.setenv(CHATTR_USE = \"", defaults_file, "\")"
      ),
      "print(chattr::chattr_defaults())",
      "app <- chattr:::app_interactive(as_job = TRUE)",
      "rp <- list(ui = app$ui, server = app$server)",
      paste0(
        "shiny::runApp(rp, host = '",
        as_job_host,
        "', port = ",
        as_job_port,
        ")"
      )
    )
    writeLines(
      app_code,
      con = run_file
    )
    rstudioapi_jobRunScript(path = run_file)
    Sys.sleep(3)
    rstudioapi_viewer(paste0("http://", as_job_host, ":", as_job_port))
  }
}

app_interactive <- function(as_job = FALSE) {
  running_as_job(as_job)
  list(ui = app_ui(), server = app_server)
}

app_init_message <- function(defaults) {
  UseMethod("app_init_message")
}

#' @export
app_init_message.default <- function(defaults) {
  print_provider(defaults)
}


rstudioapi_jobRunScript <- function(...) {
  rstudioapi::jobRunScript(...)
}

rstudioapi_viewer <- function(...) {
  rstudioapi::viewer(...)
}

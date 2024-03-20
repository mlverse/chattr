app_server <- function(input, output, session) {
  ch_env$content_hist <- NULL
  ch_env$current_stream <- NULL
  style <- app_theme_style()
  r_file_stream <- tempfile()
  r_file_complete <- tempfile()
  session$sendCustomMessage(type = "refocus", message = list(NULL))
  insertUI(
    selector = "#tabs",
    where = "beforeBegin",
    ui = fluidRow(
      style = style$ui_assistant,
      htmlOutput("stream")
    )
  )

  observeEvent(input$options, showModal(app_ui_modal()))

  app_add_history(style, input)

  observeEvent(input$saved, {
    chattr_defaults(
      type = "chat",
      max_data_files = input$i_files,
      max_data_frames = input$i_data,
      include_history = input$i_history,
      prompt = input$prompt2
    )
    removeModal()
  })

  observeEvent(input$submit, {
    if (input$prompt != "" && is.null(ch_env$current_stream)) {
      ch_history_append(user = input$prompt)
      app_add_user(input$prompt)

      updateTextAreaInput(
        inputId = "prompt",
        value = ""
      )

      session$sendCustomMessage(type = "refocus", message = list(NULL))
    }
  })

  observeEvent(input$submit, {
    if (input$prompt != "" && is.null(ch_env$current_stream)) {
      ch_submit_job(
        prompt = input$prompt,
        defaults = chattr_defaults(type = "chat"),
        prompt_build = TRUE,
        r_file_complete = r_file_complete,
        r_file_stream = r_file_stream
      )
    }
  })

  auto_invalidate <- reactiveTimer(100)

  observe({
    auto_invalidate()
    if (file_exists(r_file_complete)) {
      out <- app_server_file_complete(r_file_complete)
      Sys.sleep(0.01)
      app_add_assistant(out, input)
    }
  })

  output$stream <- renderText({
    auto_invalidate()
    if (file_exists(r_file_stream)) {
      app_server_file_stream(r_file_stream)
      markdown(ch_env$current_stream)
    }
  })

  output$provider <- renderText({
    defaults <- chattr_defaults()
    provider <- unlist(strsplit(defaults$provider, " - "))[[1]]
    paste0(provider, " - ",defaults$model)
  })

  observe({
    auto_invalidate()
    error <- r_session_error()
    if (!is.null(error)) {
      stopApp()
      print(error)
      abort("Streaming returned error")
    }
  })

  observeEvent(input$open, {
    file <- try(file.choose(), silent = TRUE)
    ext <- path_ext(file)
    if (ext == "rds") {
      rds <- readRDS(file)
      ch_history_set(rds)
      app_add_history(style, input)
      removeModal()
    }
  })

  observeEvent(input$save, {
    file <- try(file.choose(new = TRUE), silent = TRUE)
    if (path_ext(file) == "rds") {
      saveRDS(ch_history(), file)
      removeModal()
    }
  })

  observeEvent(input$close, stopApp())
}

app_add_history <- function(style, input) {
  th <- ch_history()
  for (i in seq_along(th)) {
    curr <- th[[i]]
    if (curr$role == "user") {
      app_add_user(curr$content)
    }
    if (curr$role == "assistant") {
      app_add_assistant(curr$content, input)
    }
  }
}

app_add_user <- function(content) {
  insertUI(
    selector = "#tabs",
    where = "afterEnd",
    ui = fluidRow(
      style = app_theme_style("ui_user"),
      markdown(content)
    )
  )
}

app_add_assistant <- function(content, input) {
  style <- app_theme_style("ui_assistant")
  len_hist <- length(ch_env$content_hist)
  ch <- app_split_content(content)

  walk(
    order(seq_along(ch), decreasing = TRUE),
    ~ {
      len <- len_hist + .x
      content <- ch[[.x]]$content
      prep_content <- prep_entry(content, !ui_current_markdown())
      is_code <- ch[[.x]]$is_code

      insertUI(
        selector = "#tabs",
        where = "afterEnd",
        ui = app_ui_entry(content, is_code, len) %>%
          tagAppendAttributes(style = "width: 100%;")
      )
      if (is_code) {
        observeEvent(input[[paste0("copy", len)]], {
          write_clip(prep_content, allow_non_interactive = TRUE)
          if (ide_is_rstudio()) stopApp()
        })
        observeEvent(input[[paste0("doc", len)]], {
          insertText(text = prep_content)
          stopApp()
        })
        observeEvent(input[[paste0("new", len)]], {
          documentNew(prep_entry(content, TRUE))
          stopApp()
        })
      }
    }
  )

  ch_env$content_hist <- c(
    ch_env$content_hist,
    map_chr(ch, ~ .x$content)
  )
}

prep_entry <- function(x, remove) {
  if (remove) {
    split_ch <- unlist(strsplit(x, "\n"))
    ch <- split_ch[2:(length(split_ch) - 1)]
    x <- paste0(ch, collapse = "\n")
  }
  x
}

app_split_content <- function(content) {
  split_content <- unlist(strsplit(content, "```"))
  map(
    seq_along(split_content), ~ {
      is_code <- (.x / 2) == floor(.x / 2)
      content <- split_content[.x]
      code <- NULL
      if (is_code) {
        content <- paste0("```", content, "\n```")
      }
      list(
        is_code = is_code,
        content = content
      )
    }
  )
}

app_server_file_complete <- function(r_file_complete) {
  Sys.sleep(0.02)
  out <- readRDS(r_file_complete)
  ch_history_append(assistant = out)
  file_delete(r_file_complete)
  ch_env$current_stream <- NULL
  out
}

app_server_file_stream <- function(r_file_stream) {
  current_stream <- r_file_stream %>%
    readRDS() %>%
    try(silent = TRUE)
  if (!inherits(current_stream, "try-error")) {
    ch_env$current_stream <- current_stream
  }
  invisible()
}

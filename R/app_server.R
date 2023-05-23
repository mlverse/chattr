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

  observeEvent(input$options, {
    showModal(app_ui_modal())
  })

  app_add_history(
    style = style,
    input = input
  )

  observeEvent(input$saved, {
    ch_defaults(
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
      app_add_user(input$prompt, style$ui_user)

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
        defaults = ch_defaults(type = "chat"),
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
      out <- readRDS(r_file_complete)
      app_add_assistant(
        content = out,
        style = style$ui_assistant,
        input = input
      )
      ch_history_append(
        assistant = out
      )
      file_delete(r_file_complete)
      ch_env$current_stream <- NULL
    }
  })

  output$stream <- renderText({
    auto_invalidate()
    if (file_exists(r_file_stream)) {
      current_stream <- r_file_stream %>%
        readRDS() %>%
        try(silent = TRUE)
      if (!inherits(current_stream, "try-error")) {
        ch_env$current_stream <- current_stream
      }
      markdown(ch_env$current_stream)
    }
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
      app_add_history(
        style = style,
        input = input
      )
      removeModal()
    }
  })

  observeEvent(input$save, {
    file <- try(file.choose(new = TRUE), silent = TRUE)
    ext <- path_ext(file)
    if (ext == "rds") {
      saveRDS(
        ch_history(),
        file
      )
      removeModal()
    }
  })

  observeEvent(input$close, {
    stopApp()
  })
}

app_add_history <- function(style, input) {
  th <- ch_history()
  for (i in seq_along(th)) {
    curr <- th[[i]]
    if (curr$role == "user") {
      app_add_user(curr$content, style$ui_user)
    }
    if (curr$role == "assistant") {
      app_add_assistant(curr$content, style$ui_assistant, input)
    }
  }
}

app_add_user <- function(content, style) {
  insertUI(
    selector = "#tabs",
    where = "afterEnd",
    ui = fluidRow(
      style = style,
      markdown(content)
    )
  )
}

app_add_assistant <- function(content, style, input) {
  len_hist <- length(ch_env$content_hist)
  ch <- app_split_content(content)

  walk(
    order(seq_along(ch), decreasing = TRUE),
    ~ {
      len <- len_hist + .x
      insertUI(
        selector = "#tabs",
        where = "afterEnd",
        ui = app_ui_entry(
          content = ch[[.x]]$content,
          is_code = ch[[.x]]$is_code,
          no_id = len
        ) %>%
          tagAppendAttributes(style = "width: 100%;")
      )
      if (ch[[.x]]$is_code) {
        observeEvent(input[[paste0("copy", len)]], {
          ch <- prep_entry(ch[[.x]]$content)
          write_clip(ch, allow_non_interactive = TRUE)
          if (ide_is_rstudio()) stopApp()
        })
        observeEvent(input[[paste0("doc", len)]], {
          ch <- prep_entry(ch[[.x]]$content)
          insertText(text = ch)
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

prep_entry <- function(x) {
  if (!ui_current_markdown()) {
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

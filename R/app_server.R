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
      include_data_files = input$i_files,
      include_data_frames = input$i_data,
      include_history = input$i_history,
      prompt = input$prompt2
    )
    removeModal()
  })

  observeEvent(input$submit, {
    if (input$prompt != "") {
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
    if (input$prompt != "") {
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
  if (grepl("```", content)) {
    split_content <- unlist(strsplit(content, "```"))
  } else {
    split_content <- content
  }
  content_hist <- ch_env$content_hist
  current_history <- NULL
  current_code <- NULL
  for (i in seq_along(split_content)) {
    curr_content <- split_content[i]
    if ((i / 2) == floor(i / 2)) {
      curr_content <- paste0("```", curr_content, "\n```")
      curr_split <- strsplit(curr_content, "\n")
      content_hist <- c(content_hist, curr_content)
      current_history <- c(current_history, curr_content)
      current_code <- c(current_code, TRUE)
    } else {
      current_history <- c(current_history, curr_content)
      current_code <- c(current_code, FALSE)
    }
  }

  for (i in seq_along(current_history)) {
    curr_content <- current_history[length(current_history) - i + 1]
    insertUI(
      selector = "#tabs",
      where = "afterEnd",
      ui = app_entry(
        content = curr_content,
        is_code = current_code[i],
        no_id = length(content_hist)
        ) %>%
        tagAppendAttributes(style = "width: 100%;")
    )
  }

  walk(
    seq_along(content_hist),
    ~ {
      observeEvent(input[[paste0("copy", .x)]], {
        write_clip(content_hist[.x], allow_non_interactive = TRUE)
        if (ide_is_rstudio()) stopApp()
      })
      observeEvent(input[[paste0("doc", .x)]], {
        ch <- content_hist[.x]
        if (!ui_current_markdown()) {
          split_ch <- unlist(strsplit(ch, "\n"))
          ch <- split_ch[2:(length(split_ch) - 1)]
          ch <- paste0(ch, collapse = "\n")
        }
        insertText(text = ch)
        stopApp()
      })
    }
  )

  ch_env$content_hist <- content_hist
}

app_entry <- function(content, is_code, no_id) {
  app_style <- app_theme_style()
  style <- app_style$ui_assistant
  fluidRow(
    style = style,
    column(
      width = 12,
      fluidRow(
        align = "right",
        column(width = 10, div()) %>%
          tagAppendAttributes(style = "width: 80%;"),
        column(
          width = 2,
          if (is_code) {
            tags$div(
              style = "display:inline-block",
              title = "Copy to clipboard",
              actionButton(
                paste0("copy", no_id),
                icon = icon("clipboard"),
                label = "",
                style = app_style$ui_paste
              )
            )
          },
          if (is_code & ide_is_rstudio()) {
            tags$div(
              style = "display:inline-block",
              title = "Send to document",
              actionButton(
                paste0("doc", no_id),
                icon = icon("file"),
                label = "",
                style = app_style$ui_paste
              )
            )
          },
          style = "padding: 0px"
        ) %>%
          tagAppendAttributes(style = "width: 20%;")
      ),
      fluidRow(
        column(
          width = 12,
          markdown(content)
        )
      )
    )
  )
}

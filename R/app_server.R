app_server <- function(input, output, session) {
  ch_env$content_hist <- NULL
  style <- app_theme_style()
  rs <- r_session_start()
  ch_env$stream_output <- ""
  app_add_history(input)
  auto_invalidate <- reactiveTimer(100)
  session$sendCustomMessage(type = "refocus", message = list(NULL))

  insertUI(
    selector = "#tabs",
    where = "beforeBegin",
    ui = fluidRow(
      style = style$ui_assistant,
      htmlOutput("stream")
    )
  )

  output$stream <- renderText({
    auto_invalidate()
    if (rs$get_state() == "busy") {
      curr_stream <- rs$read_output()
      ch_env$stream_output <- paste0(ch_env$stream_output, curr_stream)
      markdown(ch_env$stream_output)
    }
  })

  output$provider <- renderText({
    defaults <- chattr_defaults()
    defaults$label
  })

  observeEvent(
    input$options,
    showModal(app_ui_modal())
    )

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
    if (input$prompt != "" && rs$get_state() == "idle") {
      ch_history_append(user = input$prompt)
      app_add_user(input$prompt)
      updateTextAreaInput(
        inputId = "prompt",
        value = ""
      )
      session$sendCustomMessage(type = "refocus", message = list(NULL))

      rs$call(
        func = function(prompt) {
          chattr::ch_submit(
            defaults = chattr::chattr_defaults(type = "chat"),
            prompt = prompt, stream = TRUE,
            preview = FALSE,
            prompt_build = TRUE
            )
        },
        args = list(prompt = input$prompt)
      )
    }
  })

  observeEvent(input$open, {
    file <- try(file.choose(), silent = TRUE)
    ext <- path_ext(file)
    if (ext == "rds") {
      rds <- readRDS(file)
      ch_history_set(rds)
      app_add_history(input)
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

  observe({
    auto_invalidate()
    if (rs$get_state() == "idle" && ch_env$stream_output != "") {
      Sys.sleep(0.02)
      ch_history_append(assistant = ch_env$stream_output)
      app_add_assistant(ch_env$stream_output, input)
      ch_env$stream_output <- ""
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
}

app_add_history <- function(input) {
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

r_session_start <- function() {
  if (is.null(ch_env$r_session)) {
    opts <-  r_session_options()
    opts$stdout <- "|"
    opts$stderr <- "|"
    ch_env$r_session <- r_session$new(options = opts)
  }
  ch_env$r_session
}

r_session_error <- function() {
  out <- NULL
  if (!is.null(ch_env$r_session)) {
    read_session <- ch_env$r_session$read()
    if (!is.null(read_session)) {
      out <- read_session$error
    }
  }
  out
}

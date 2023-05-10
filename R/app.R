#' Starts a Shiny app interface to the LLM
#' @param viewer Specifies where the Shiny app is going to display
#' @param as_job App runs as an RStudio IDE Job. Defaults to FALSE. If set to
#' TRUE, the Shiny app will not be able to transfer the code blocks directly to
#' the document, or console, in the IDE.
#' @param as_job_port Port to use for the Shiny app. Applicable only if `as_job`
#' is set to TRUE.
#' @param as_job_host Host IP to use for the Shiny app. Applicable only if `as_job`
#' is set to TRUE.
#' @export
tidychat_app <- function(viewer = c("viewer", "dialog"),
                         as_job = FALSE,
                         as_job_port = getOption("shiny.port", 7788),
                         as_job_host = getOption("shiny.host", "127.0.0.1")) {
  td <- tc_defaults(type = "chat")
  cli_li("Provider: {td$provider}")
  cli_li("Model: {td$model}")

  if (viewer[1] == "dialog") {
    viewer <- dialogViewer(
      dialogName = glue("tidychat - {td$provider} - {td$model}"),
      width = 800
    )
  } else {
    viewer <- paneViewer()
  }

  if (!as_job) {
    app <- app_interactive(as_job = as_job)
    runGadget(app$ui, app$server, viewer = viewer)
  } else {
    run_file <- tempfile()
    writeLines(
      c(
        "app <- tidychat:::app_interactive(as_job = TRUE)\n",
        "rp <- list(ui = app$ui, server = app$server)\n",
        paste0("shiny::runApp(rp, host = '",
               as_job_host,
               "', port = ",
               as_job_port,
               ")")
      ),
      con = run_file
    )
    jobRunScript(path = run_file)
    Sys.sleep(3)
    viewer(paste0("http://", as_job_host, ":", as_job_port))
  }
}

app_interactive <- function(as_job = FALSE) {
  tc_env$content_hist <- NULL
  style <- app_theme_style()

  ui <- fluidPage(
    theme = bs_theme(
      bg = style$color_bg,
      fg = style$color_fg
    ),
    tags$style(
      type = "text/css",
      ".form-control {font-size: 80%; margin-left: 5px; margin-top: 5px;}"
    ),
    tags$style(
      type = "text/css",
      ".shiny-tab-input {border-width: 0px;}"
    ),
    fixedPanel(
      width = "100%",
      left = 1,
      fluidRow(
        column(
          width = 8,
          textAreaInput(
            inputId = "prompt",
            label = NULL,
            width = "100%",
            resize = "horizontal"
          )
        ),
        column(
          width = 2,
          actionButton("add", "Submit", style = style$ui_submit)
        ),
        column(
          width = 2,
          fluidRow(
            actionLink("save", "Save chat"),
            actionLink("open", "Open chat"),
            style = "margin-top: 5px; font-size: 70%;",
            checkboxInput("include", "Prompt+", value = TRUE)
          )
        )
      ),
      style = paste0(
        "z-index: 10; background-color:", style$color_top
      )
    ),
    absolutePanel(
      top = 93,
      width = "95%",
      tabsetPanel(
        type = "tabs",
        id = "tabs"
      )
    )
  )

  server <- function(input, output, session) {
    r_file_stream <- tempfile()
    r_file_complete <- tempfile()

    insertUI(
      selector = "#tabs",
      where = "beforeBegin",
      ui = fluidRow(
        style = style$ui_assistant,
        htmlOutput("stream")
      )
    )

    app_add_history(
      style = style,
      input = input,
      as_job = as_job
    )

    observeEvent(input$add, {
      tc_history_append(user = input$prompt)
      app_add_user(input$prompt, style$ui_user)

      updateTextAreaInput(
        inputId = "prompt",
        value = ""
      )
    })

    observeEvent(input$add, {
      tc_submit_job(
        prompt = input$prompt,
        defaults = tc_defaults(type = "chat"),
        prompt_build = input$include,
        r_file_complete = r_file_complete,
        r_file_stream = r_file_stream
      )
    })

    auto_invalidate <- reactiveTimer(100)

    observe({
      auto_invalidate()
      if (file_exists(r_file_complete)) {
        out <- readRDS(r_file_complete)
        app_add_assistant(
          content = out,
          style = style$ui_assistant,
          input = input,
          as_job = as_job
        )
        tc_history_append(
          assistant = out
        )
        file_delete(r_file_complete)
      }
    })

    output$stream <- renderText({
      auto_invalidate()
      if (file_exists(r_file_stream)) {
        try(markdown(readRDS(r_file_stream)))
      }
    })

    observeEvent(input$open, {
      file <- file.choose()
      ext <- path_ext(file)
      if (ext == "rds") {
        rds <- readRDS(file)
        tc_history_set(rds)
        app_add_history(
          style = style,
          input = input,
          as_job = as_job
        )
      }
    })

    observeEvent(input$save, {
      file <- file.choose(new = TRUE)
      ext <- path_ext(file)
      if (ext == "rds") {
        saveRDS(
          tc_history_get(),
          file
        )
      }
    })
  }

  list(ui = ui, server = server)
}

app_add_history <- function(style, input, as_job) {
  th <- tc_history_get()
  for (i in seq_along(th)) {
    curr <- th[[i]]
    if (curr$role == "user") {
      app_add_user(curr$content, style$ui_user)
    }
    if (curr$role == "assistant") {
      app_add_assistant(curr$content, style$ui_assistant, input, as_job)
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

app_add_assistant <- function(content, style, input, as_job = FALSE) {
  if (grepl("```", content)) {
    split_content <- unlist(strsplit(content, "```"))
  } else {
    split_content <- content
  }

  content_hist <- tc_env$content_hist
  for (i in seq_along(split_content)) {
    curr_content <- split_content[length(split_content) - i + 1]
    if ((i / 2) == floor(i / 2)) {
      curr_content <- paste0("```", curr_content, "\n```")
      curr_split <- strsplit(curr_content, "\n")
      content_hist <- c(content_hist, curr_content)
      is_code <- TRUE
    } else {
      is_code <- FALSE
    }

    if (as_job) {
      tabs_1 <- 11
      tabs_2 <- 1
    } else {
      tabs_1 <- 9
      tabs_2 <- 3
    }

    insertUI(
      selector = "#tabs",
      where = "afterEnd",
      ui = fluidRow(
        style = style,
        fluidRow(
          column(width = tabs_1, div()),
          column(
            width = tabs_2,
            if (is_code) {
              actionButton(
                paste0("copy", length(content_hist)),
                icon = icon("clipboard"),
                label = "",
                style = "padding:4px; font-size:60%"
              )
            },
            if (is_code & !as_job) {
              actionButton(
                paste0("doc", length(content_hist)),
                icon = icon("file"),
                label = "To Document",
                style = "padding:4px; font-size:60%"
              )
            }
          )
        ),
        fluidRow(
          markdown(curr_content)
        )
      )
    )
  }

  walk(
    seq_along(content_hist),
    ~ {
      observeEvent(input[[paste0("copy", .x)]], {
        write_clip(content_hist[.x], allow_non_interactive = TRUE)
        if (!as_job) stopApp()
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

  tc_env$content_hist <- content_hist
}

app_theme_style <- function() {
  ti <- getThemeInfo()

  color_bg <- app_theme_rgb_to_hex(ti$background)
  color_fg <- app_theme_rgb_to_hex(ti$foreground)

  if (ti$dark) {
    color_user <- "#3E4A56"
      color_top <- "#242B31"
        color_bk <- "#f1f6f8"
  } else {
    color_user <- "#f1f6f8"
      color_top <- "#E1E2E5"
        color_bk <- "#3E4A56"
  }

  ui_paste <- c(
    "padding: 4px",
    "font-size: 60%",
    paste0("color:", color_bg),
    paste0("background-color:", color_bk)
  )

  ui_submit <- c(
    "font-size: 80%",
    "padding-top: 3px",
    "padding-bottom: 3px",
    "margin-top: 15px",
    paste0("color:", color_bg),
    paste0("background-color:", color_bk)
  )

  ui_style <- c(
    "padding-top: 5px",
    "padding-left: 5px",
    "padding-right: 5px",
    "font-size: 80%"
  )

  ui_user <- c(
    ui_style,
    "border-style: solid",
    "border-width: 1px",
    "margin-top: 10px",
    "margin-bottom: 10px",
    "margin-left: 50px",
    "padding: 2px",
    paste0("color:", color_bg),
    paste0("background-color:", color_bk),
    paste0("border-color:", color_top)
  )

  ui_assistant <- c(
    ui_style,
    "margin-left: 0px",
    paste0("color:", color_fg),
    paste0("background-color:", color_user),
    paste0("border-color:", color_bg)
  )

  list(
    color_bg = color_bg,
    color_fg = color_fg,
    color_top = color_top,
    color_user = color_user,
    ui_submit = style_collapse(ui_submit),
    ui_user = style_collapse(ui_user),
    ui_assistant = style_collapse(ui_assistant),
    ui_paste = style_collapse(ui_paste)
  )
}

style_collapse <- function(x) {
  paste0(paste0(x, collapse = ";"), ";")
}

app_theme_rgb_to_hex <- function(x) {
  x1 <- sub("rgb\\(", "", x)
  x1 <- sub("\\)", "", x1)
  x2 <- unlist(strsplit(x1, ","))
  rgb(x2[1], x2[2], x2[3], maxColorValue = 255)
}

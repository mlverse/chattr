#' Starts a Shiny app interface to the LLM
#' @param viewer Specifies where the Shiny app is going to display
#' @param as_job App runs as an RStudio IDE Job. Defaults to FALSE. If set to
#' TRUE, the Shiny app will not be able to transfer the code blocks directly to
#' the document, or console, in the IDE.
#' @param as_job_port Port to use for the Shiny app. Applicable only if `as_job`
#' is set to TRUE.
#' @param as_job_port Host IP to use for the Shiny app. Applicable only if `as_job`
#' is set to TRUE.
#' @export
tidychat_app <- function(viewer = dialogViewer("tidychat", width = 800),
                         as_job = FALSE,
                         as_job_port = getOption("shiny.port", 7788),
                         as_job_host = getOption("shiny.host", "127.0.0.1")) {
  if (!as_job) {
    app <- app_interactive(as_job = as_job)
    runGadget(app$ui, app$server, viewer = viewer)
  } else {
    run_file <- tempfile()
    writeLines(
      c(
        "app <- tidychat:::app_interactive(as_job = TRUE)\n",
        "rp <- list(ui = app$ui, server = app$server)\n",
        paste0("shiny::runApp(rp, host = '", as_job_host, "', port = ", as_job_port, ")")
      ),
      con = run_file
    )
    rstudioapi::jobRunScript(path = run_file)
    Sys.sleep(3)
    rstudioapi::viewer(paste0("http://", as_job_host, ":", as_job_port))
  }
}

app_interactive <- function(as_job = FALSE) {
  tidychat_env$content_hist <- NULL
  style <- app_theme_style()

  if (tidychat_debug_get()) {
    test_file <- readRDS(system.file("history/raw.rds", package = "tidychat"))
    tidychat_history_set(test_file)
  }

  ui <- fluidPage(
    theme = bs_theme(
      bg = style$color_bg,
      fg = style$color_fg
    ),
    fixedPanel(
      width = "100%",
      left = -1,
      fluidRow(
        column(width = 1, div()),
        column(
          width = 7,
          textAreaInput(
            "prompt", "",
            width = "100%",
            resize = "horizontal"
          )
        ),
        column(
          width = 2,
          br(), br(),
          actionButton("add", "Submit", style = "font-size:120%;")
        ),
        column(
          width = 2,
          br(),
          fluidRow(
            actionLink("save", "Save chat"),
            actionLink("open", "Open chat")
          ),
          checkboxInput("include", "Prompt+", value = TRUE)
        )
      ),
      style = paste0("font-size:80%; z-index: 10; background-color:", style$color_top)
    ),
    absolutePanel(
      top = 95,
      width = "95%",
      tabsetPanel(
        type = "tabs",
        id = "tabs"
      )
    )
  )

  server <- function(input, output, session) {
    app_add_history(
      style = style,
      input = input,
      as_job = as_job
    )

    observeEvent(input$add, {
      app_add_user(input$prompt, style$ui_user)

      updateTextAreaInput(
        inputId = "prompt",
        value = ""
      )
    })

    observeEvent(input$add, {
      chat <- app_get_chat(
        prompt = input$prompt,
        include = input$include
      )

      app_add_assistant(chat$assistant, style$ui_assistant, input, as_job)
    })

    observeEvent(input$open, {
      file <- file.choose()
      ext <- fs::path_ext(file)
      if (ext == "rds") {
        rds <- readRDS(file)
        tidychat_history_set(rds)
        app_add_history(
          style = style,
          input = input,
          as_job = as_job
        )
      }
    })

    observeEvent(input$save, {
      file <- file.choose(new = TRUE)
      ext <- fs::path_ext(file)
      if (ext == "rds") {
        saveRDS(
          tidychat_history_get(),
          file
        )
      }
    })
  }

  list(ui = ui, server = server)
}

app_add_history <- function(style, input, as_job) {
  th <- tidychat_history_get()
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

  content_hist <- tidychat_env$content_hist

  for (i in seq_along(split_content)) {
    curr_content <- split_content[length(split_content) - i + 1]

    if (grepl("\\{r\\}", curr_content)) {
      is_code <- TRUE

      hist_content <- sub("\\{r\\}\n", "", curr_content)
      hist_content <- sub("\\{r\\}", "", hist_content)
      content_hist <- c(content_hist, hist_content)

      curr_content <- paste0("```", curr_content, "```")
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
        if (ui_current() == "markdown") {
          ch <- paste0("```{r}\n", ch, "\n```")
        }
        rstudioapi::insertText(text = ch)
        stopApp()
      })
    }
  )

  tidychat_env$content_hist <- content_hist
}

app_theme_style <- function() {
  ti <- rstudioapi::getThemeInfo()

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

  ui_style <- c(
    "padding-top: 5px",
    "padding-left: 5px",
    "padding-right: 5px"
  )

  ui_user <- c(
    ui_style,
    "border-style: solid",
    "border-width: 1px",
    "margin-top: 10px",
    "margin-bottom: 10px",
    "margin-left: 50px",
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
    ui_user = paste0(paste0(ui_user, collapse = ";"), ";"),
    ui_assistant = paste0(paste0(ui_assistant, collapse = ";"), ";")
  )
}

app_theme_rgb_to_hex <- function(x) {
  x1 <- sub("rgb\\(", "", x)
  x1 <- sub("\\)", "", x1)
  x2 <- unlist(strsplit(x1, ","))
  rgb(x2[1], x2[2], x2[3], maxColorValue = 255)
}

app_get_chat <- function(prompt, include = TRUE) {
  ret <- list()
  if (tidychat_debug_get()) {
    ret$assistant <- "some text\n```{r}\nmtcars\n```\nmore text\n```{r}\niris\n```"
    ret$user <- "test"
    Sys.sleep(2)
  } else {
    invisible(
      tidychat_send(
        prompt = prompt,
        type = "chat",
        prompt_build = include
      )
    )

    chat_history <- tidychat_history_get()
    chat_length <- length(chat_history)

    ret$assistant <- chat_history[[chat_length]]$content
    ret$user <- chat_history[[chat_length - 1]]$content
  }
  ret
}

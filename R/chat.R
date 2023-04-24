#' @rdname tidychat_prompt
#' @import shiny
#' @export
tidychat_interactive <- function() {
  ti <- rstudioapi::getThemeInfo()

  color_bg <- theme_rgb_to_hex(ti$background)
  color_fg <- theme_rgb_to_hex(ti$foreground)

  if (ti$dark) {
    color_user <- "#3E4A56;"
    color_top <- "#242B31;"
  } else {
    color_user <- "#f1f6f8;"
    color_top <- "#E1E2E5;"
  }

  ui <- fluidPage(
    theme = bslib::bs_theme(
      bg = color_bg,
      fg = color_fg
    ),
    fixedPanel(
      width = "100%",
      left = -1,
      fluidRow(
        column(width = 1, div()),
        column(
          width = 9,
          textAreaInput(
            "prompt", "",
            width = "70%",
            resize = "horizontal"
          )
        ),
        column(
          width = 2,
          br(),
          actionButton("add", "Submit"),
          checkboxInput("include", "Enhanced prompt?", value = TRUE)
        )
      ),
      style = paste0("
      opacity: 1;
      z-index: 10;
      background-color:", color_top)
    ),
    absolutePanel(
      top = 120, width = "95%",
      tabsetPanel(
        type = "tabs",
        id = "tabs"
      )
    )
  )

  ui_style <- "
  padding-top: 5px;
  padding-left: 5px;
  padding-right: 5px;"

  ui_user <- paste0(
    ui_style, "
                    border-style: solid;
                    border-width: 1px;
                    margin-top: 10px;
                    margin-bottom: 10px;
                    margin-left: 50px;
                    background-color:", color_bg, ";",
    "color:", color_fg, ";",
    "border-color:", color_fg, ";"
  )

  ui_assistant <- paste0(
    ui_style, "
                         margin-left: 0px;
                         background-color:", color_user, ";",
    "color:", color_fg, ";",
    "border-color:", color_bg, ";"
  )

  server <- function(input, output, session) {
    content_hist <- NULL
    observeEvent(input$add, {
      # invisible(
      #   tidychat:::tidychat_send(
      #     prompt = input$prompt,
      #     type = "chat",
      #     enhanced_prompt = input$include
      #   )
      # )
      #
      # chat_history <- tidychat_history(raw = TRUE)
      # chat_length <- length(chat_history)
      #
      # assistant <- chat_history[[chat_length]]
      # user <- chat_history[[chat_length - 1]]

      assistant <- list()
      assistant$content <- "some text\n```{r}\nmtcars\n```\nmore text\n```{r}\niris\n```"

      user <- list()
      user$content <- "test"

      assistant_content <- assistant$content

      split_content <- unlist(strsplit(assistant_content, "```"))

      for (i in seq_along(split_content)) {
        curr_content <- split_content[length(split_content) - i + 1]

        if (grepl("\\{r\\}", curr_content)) {
          is_code <- TRUE
          hist_content <- sub("\\{r\\}\n", "", curr_content)
          hist_content <- sub("\\{r\\}", "", hist_content)
          curr_content <- paste0("```", curr_content, "```")
          content_hist <- c(content_hist, hist_content)
        } else {
          is_code <- FALSE
        }

        insertUI(
          selector = "#tabs",
          where = "afterEnd",
          ui = fluidRow(
            style = ui_assistant,
            fluidRow(
              column(width = 9, div()),
              column(
                width = 3,
                if (is_code) {
                  actionButton(
                    paste0("copy", length(content_hist)),
                    icon = icon("clipboard"),
                    label = "Copy",
                    style = "padding:4px; font-size:60%"
                  )
                },
                if (is_code) {
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

      insertUI(
        selector = "#tabs",
        where = "afterEnd",
        ui = fluidRow(
          style = ui_user,
          markdown(user$content)
        )
      )

      updateTextAreaInput(
        inputId = "prompt",
        value = ""
      )



      purrr::walk(
        seq_along(content_hist),
        ~ {
          observeEvent(input[[paste0("copy", .x)]], {
            clipr::write_clip(content_hist[.x])
            stopApp()
          })
          observeEvent(input[[paste0("doc", .x)]], {
            rstudioapi::insertText(text = content_hist[.x])
            stopApp()
          })
        }
      )
    })
  }

  runGadget(ui, server, viewer = dialogViewer("tidychat", width = 900))
}

theme_rgb_to_hex <- function(x) {
  x1 <- sub("rgb\\(", "", x)
  x1 <- sub("\\)", "", x1)
  x2 <- unlist(strsplit(x1, ","))
  rgb(x2[1], x2[2], x2[3], maxColorValue = 255)
}

app_ui <- function() {
  style <- app_theme_style()

  fluidPage(
    responsive = FALSE,
    theme = bs_theme(
      bg = style$color_bg,
      fg = style$color_fg
    ),
    tags$style(
      type = "text/css",
      paste0(
        ".form-control {", style$ui_text, "}",
        ".form-group {padding: 1px; margin: 1px;}",
        ".checkbox {font-size: 70%; padding: 1px}",
        ".shiny-tab-input {border-width: 0px;}",
        ".col-sm-11 {margin: 0px; padding-left: 5px; padding-right: 5px;}",
        ".col-sm-10 {margin: 0px; padding-left: 0px; padding-right: 0px;}",
        ".col-sm-2 {margin: 0px; padding-left: 0px; padding-right: 0px;}",
        ".col-sm-1 {margin: 0px; padding-left: 7px; padding-right: 0px;}"
      )
    ),
    tags$head(
      tags$script(
        "Shiny.addCustomMessageHandler('refocus', function(NULL) {
          document.getElementById('prompt').focus();
        });"
      )
    ),
    tags$head(
      tags$script("
      $(document).keyup(function(event) {
         if ((event.keyCode == 27)) {
          $('#close').click();
      }});")
    ),
    actionButton(
      inputId = "close",
      label = NULL,
      style = style$ui_submit
    ),
    fixedPanel(
      width = "100%",
      left = 0.1,
      top = 0,
      fluidRow(
        column(
          width = 11,
          textAreaInput(
            inputId = "prompt",
            label = NULL,
            width = "100%",
            resize = "none"
          )
        ) %>%
          tagAppendAttributes(style = "width: 85%;"),
        column(
          width = 1,
          actionButton(
            inputId = "submit",
            label = "Submit",
            style = style$ui_submit
          ),
          actionButton(
            inputId = "options",
            label = NULL,
            icon = icon("gear"),
            style = style$ui_submit
          )
        ) %>%
          tagAppendAttributes(style = "width: 15%;"),
      ),
      style = style$ui_panel
    ),
    absolutePanel(
      top = 52,
      left = "1%",
      width = "98%",
      tabsetPanel(
        type = "tabs",
        id = "tabs"
      )
    )
  )
}

app_ui_modal <- function() {
  style <- app_theme_style()

  tc <- ch_defaults(type = "chat")

  prompt2 <- tc$prompt %>%
    process_prompt() %>%
    paste(collapse = "\n")
  modalDialog(

    p("Save / Load Chat"),
    if (ide_is_rstudio()) actionButton("save", "Save chat", style = style$ui_paste),
    if (ide_is_rstudio()) actionButton("open", "Open chat", style = style$ui_paste),
    hr(),
    textAreaInput("prompt2", "Prompt", prompt2),
    br(),
    textInput("i_data", "Max Data Frames", tc$max_data_frames),
    textInput("i_files", "Max Data Files", tc$max_data_files),
    checkboxInput("i_history", "Include Chat History", tc$include_history),
    actionButton("saved", "Save", style = style$ui_paste),
    easyClose = TRUE,
    footer = tagList()
  )
}

app_ui_entry <- function(content, is_code, no_id) {
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

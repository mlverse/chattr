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
      icon = icon("close"),
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

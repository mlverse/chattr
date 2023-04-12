library(tidychat)

#tidychat::tidychat_debug_set_true()

ui <- fluidPage(
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
    style = "
    opacity: 1;
    z-index: 10;
    background-color: #ffd;
    "
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
border-color: #ddd;
border-style: solid;
border-width: 1px;
padding-top: 5px;
padding-left: 5px;
padding-right: 5px;
margin-top: 10px;"

ui_user <- paste0(ui_style, " margin-left: 50px; background-color: #ffd;")
ui_assistant <- paste0(ui_style, " margin-left: 0px; background-color: #fff;")

server <- function(input, output, session) {
  observeEvent(input$add, {
    showModal(modalDialog(
      title = "tidychat",
      "Communicating with model...",
      footer = NULL
    ))

    invisible(
      tidychat:::tidychat_send(
        prompt = input$prompt,
        type = "chat",
        enhanced_prompt = input$include
      )
    )

    chat_history <- tidychat_history(raw = TRUE)
    chat_length <- length(chat_history)

    assistant <- chat_history[[chat_length]]
    user <- chat_history[[chat_length - 1]]

    insertUI(
      selector = "#tabs",
      where = "afterEnd",
      ui = fluidRow(
        style = ui_assistant,
        markdown(assistant$content)
      )
    )

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

    removeModal()
  })
}

shinyApp(ui, server)

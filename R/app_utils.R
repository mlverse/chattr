app_theme_style <- function() {

  if(ide_is_rstudio()) {
    ti <- getThemeInfo()
    color_bg <- app_theme_rgb_to_hex(ti$background)
    color_fg <- app_theme_rgb_to_hex(ti$foreground)
    color_dark <- ti$dark
  } else {
    color_bg <- "#fff"
    color_fg <- "#000"
    color_dark <- TRUE
  }

  if (color_dark) {
    color_user <- "#3E4A56"
    color_top <- "#242B31"
    color_bk <- "#f1f6f8"
  } else {
    color_user <- "#f1f6f8"
    color_top <- "#E1E2E5"
    color_bk <- "#3E4A56"
  }

  ui_panel <- c(
    "z-index: 10",
    paste0("background-color:", color_top)
  )

  ui_paste <- c(
    "padding-top: 4px",
    "padding-bottom: 4px",
    "padding-left: 10px",
    "padding-right: 10px",
    "font-size: 60%",
    paste0("color:", color_bg),
    paste0("background-color:", color_bk)
  )

  ui_text <- c(
    "font-size: 80%",
    "margin-left: 8px",
    "padding: 5px"
  )

  ui_submit <- c(
    "font-size: 55%",
    "padding-top: 3px",
    "padding-bottom: 3px",
    "padding-left: 5px",
    "padding-right: 5px",
    paste0("color:", color_bg),
    paste0("background-color:", color_bk)
  )

  ui_options <- c(
    "font-size: 90%",
    "padding-top: 3px",
    "padding-bottom: 3px",
    "padding-left: 5px",
    "padding-right: 5px",
    paste0("color:", color_bg),
    paste0("background-color:", color_bk)
  )

  ui_user <- c(
    "border-style: solid",
    "border-width: 1px",
    "margin-top: 10px",
    "margin-bottom: 10px",
    "margin-left: 50px",
    "margin-right: 0px",
    "padding-top: 5px",
    "padding-bottom: 2px",
    "padding-left: 0px",
    "padding-right: 0px",
    "font-size: 80%",
    paste0("color:", color_bg),
    paste0("background-color:", color_bk),
    paste0("border-color:", color_top)
  )

  ui_assistant <- c(
    "margin: 0px",
    "padding: 0px",
    "font-size: 80%",
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
    ui_paste = style_collapse(ui_paste),
    ui_text = style_collapse(ui_text),
    ui_panel = style_collapse(ui_panel),
    ui_options = style_collapse(ui_options)
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

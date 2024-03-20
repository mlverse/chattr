app_theme_style <- function(x = NULL) {
  if ((ide_is_rstudio() && !ch_debug_get()) | running_as_job()) {
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

  ui_color_bg <- paste("color:", color_bg)
  ui_color_bk <- paste("background-color:", color_bk)

  ui_panel <- c(
    "z-index: 10",
    paste("background-color:", color_top)
  )

  ui_paste <- c(
    "padding-top: 4px",
    "padding-bottom: 4px",
    "padding-left: 10px",
    "padding-right: 10px",
    "font-size: 60%",
    ui_color_bg,
    ui_color_bk
  )

  ui_text <- c(
    "font-size: 80%",
    "margin-left: 8px",
    "padding: 5px"
  )

  ui_general <- c(
    "padding-top: 3px",
    "padding-bottom: 3px",
    "padding-left: 5px",
    "padding-right: 5px",
    ui_color_bg,
    ui_color_bk
  )

  ui_submit <- c(
    "font-size: 55%",
    ui_general
  )

  ui_options <- c(
    "font-size: 90%",
    ui_general
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
    ui_color_bg,
    ui_color_bk,
    paste("border-color:", color_top)
  )

  ui_assistant <- c(
    "margin: 0px",
    "padding: 0px",
    "font-size: 80%",
    paste("color:", color_fg),
    paste("background-color:", color_user),
    paste("border-color:", color_bg)
  )

  out <- list(
    color_bg = color_bg,
    color_fg = color_fg,
    color_bk = color_bk,
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
  if (!is.null(x)) {
    out <- out[[x]]
  }
  out
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

running_as_job <- function(x = NULL) {
  if (!is.null(x)) {
    ch_env$as_job <- x
  } else {
    if (is.null(ch_env$as_job)) {
      ch_env$as_job <- FALSE
    }
  }
  ch_env$as_job
}

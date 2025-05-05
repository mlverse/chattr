#' @importFrom purrr map_chr map_lgl map set_names walk imap
#' @importFrom purrr iwalk discard keep imap_lgl reduce
#' @importFrom rlang %||% abort is_named is_interactive
#' @importFrom utils capture.output head menu
#' @importFrom clipr write_clip
#' @importFrom bslib bs_theme
#' @importFrom grDevices rgb
#' @import rstudioapi
#' @import processx
#' @import ellmer
#' @import httr2
#' @import shiny
#' @import glue
#' @import yaml
#' @import cli
#' @import fs

## usethis namespace: start
#' @importFrom lifecycle deprecated
## usethis namespace: end
ch_env <- new.env()
ch_env$valid_uis <- c("console", "chat", "notebook", "script")
ch_env$stream_output <- ""
ch_env$stream_status <- "idle"

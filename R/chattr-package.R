#' @importFrom purrr map_chr map_lgl map imap set_names walk flatten
#' @importFrom purrr iwalk discard keep imap_lgl reduce transpose
#' @importFrom rlang %||% abort is_named is_interactive is_na
#' @importFrom utils capture.output head menu
#' @importFrom clipr write_clip
#' @importFrom bslib bs_theme
#' @importFrom grDevices rgb
#' @import rstudioapi
#' @import processx
#' @import callr
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
ch_env$ellmer_output <- NULL
ch_env$ellmer_status <- "idle"

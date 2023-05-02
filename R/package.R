#' @import callr
#' @import httr2
#' @import shiny
#' @import glue
#' @import yaml
#' @import cli
#' @import fs
#' @import rstudioapi
#' @importFrom bslib bs_theme
#' @importFrom clipr write_clip
#' @importFrom grDevices rgb
#' @importFrom utils capture.output
#' @importFrom purrr map_chr map_lgl map imap set_names walk reduce iwalk
#' @importFrom rlang %||% abort
tidychat_env <- new.env()
tidychat_env$stream <- list()
tidychat_env$stream$raw <- NULL
tidychat_env$stream$response <- NULL

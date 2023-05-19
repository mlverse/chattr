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
#' @importFrom rlang %||% abort is_named is_interactive
#' @importFrom purrr map_chr map_lgl map imap set_names walk
#' @importFrom purrr iwalk discard keep imap_lgl reduce

## usethis namespace: start
#' @importFrom lifecycle deprecated
## usethis namespace: end
ch_env <- new.env()

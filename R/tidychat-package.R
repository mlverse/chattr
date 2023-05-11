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
#' @importFrom purrr map_chr map_lgl map imap set_names walk
#' @importFrom purrr iwalk discard keep imap_lgl reduce
#' @importFrom rlang %||% abort is_named

## usethis namespace: start
#' @importFrom lifecycle deprecated
## usethis namespace: end
tc_env <- new.env()

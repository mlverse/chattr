library(rvest)
library(purrr)
library(rstudioapi)

providers <- function() {

  ellmer_url <- "https://ellmer.tidyverse.org/"
  readme <- read_html(paste0(ellmer_url, "index.html"))

  readme_lists <- readme |>
    html_elements("body") |>
    html_elements("div.section.level2") |>
    html_elements("ul")


  provider_li <- readme_lists[[1]] |>
    html_elements("li")


  provider_functions <- provider_li |>
    html_elements("a") |>
    html_text()

  provider_links <-provider_li |>
    html_elements("a") |>
    html_attr("href")

  provider_full_links <- paste0(ellmer_url, provider_links)

  provider_text <- provider_li |>
    html_text()

  provider_name <- provider_text |>
    strsplit(": ") |>
    map_chr(\(x) x[[1]])

  out <- NULL
  for(i in seq_along(provider_name)) {
    pr <- paste0("- ", provider_name[[i]], ": [`ellmer::", provider_functions[[i]],
                 "`](", provider_full_links[[i]], ")")
    out <- c(out, pr)
  }

  providers_start <- "<!-- providers: start -->"
  providers_end <- "<!-- providers: end -->"

  out <- c(providers_start, out, providers_end)

  out <- paste0(out, collapse = "\n")

  ac <- getActiveDocumentContext()
  content <- ac$contents

  pos_start <- as.document_position(c(which(content == providers_start), 1))
  pos_end <- as.document_position(c(which(content == providers_end), nchar(providers_end) + 1))
  pos_range <- document_range(pos_start, pos_end)
  modifyRange(pos_range, out)
}

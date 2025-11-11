ch_ollama_check <- function() {
  urls <- c(
    "http://localhost:11434",
    "http://127.0.0.1:11434"
  )
  check_urls <- urls |>
    map(~ request(.x) |>
      req_perform() |>
      try(silent = TRUE)) |>
    map_lgl(~ {
      if (inherits(.x, "httr2_response")) {
        if (.x$status_code == 200) {
          TRUE
        }
      } else {
        FALSE
      }
    })
  any(check_urls)
}

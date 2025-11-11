# Starts a Shiny app interface to the LLM

Starts a Shiny app interface to the LLM

## Usage

``` r
chattr_app(
  viewer = c("viewer", "dialog"),
  as_job = getOption("chattr.as_job", FALSE),
  as_job_port = getOption("shiny.port", 7788),
  as_job_host = getOption("shiny.host", "127.0.0.1")
)
```

## Arguments

- viewer:

  Specifies where the Shiny app is going to display

- as_job:

  App runs as an RStudio IDE Job. Defaults to FALSE. If set to TRUE, the
  Shiny app will not be able to transfer the code blocks directly to the
  document, or console, in the IDE.

- as_job_port:

  Port to use for the Shiny app. Applicable only if `as_job` is set to
  TRUE.

- as_job_host:

  Host IP to use for the Shiny app. Applicable only if `as_job` is set
  to TRUE.

## Value

A chat interface inside the 'RStudio' IDE

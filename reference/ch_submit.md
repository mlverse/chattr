# Method to integrate to new LLM API's

Method to integrate to new LLM API's

## Usage

``` r
ch_submit(
  defaults,
  prompt = NULL,
  stream = NULL,
  prompt_build = TRUE,
  preview = FALSE,
  ...
)
```

## Arguments

- defaults:

  Defaults object, generally puled from
  [`chattr_defaults()`](https://mlverse.github.io/chattr/reference/chattr_defaults.md)

- prompt:

  The prompt to send to the LLM

- stream:

  To output the response from the LLM as it happens, or wait until the
  response is complete. Defaults to TRUE.

- prompt_build:

  Include the context and additional prompt as part of the request

- preview:

  Primarily used for debugging. It indicates if it should send the
  prompt to the LLM (FALSE), or if it should print out the resulting
  prompt (TRUE)

- ...:

  Optional arguments; currently unused.

## Value

The output from the model currently in use.

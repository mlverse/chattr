# Submits prompt to LLM

Submits prompt to LLM

## Usage

``` r
chattr(prompt = NULL, preview = FALSE, prompt_build = TRUE, stream = NULL)
```

## Arguments

- prompt:

  Request to send to LLM. Defaults to NULL

- preview:

  Primarily used for debugging. It indicates if it should send the
  prompt to the LLM (FALSE), or if it should print out the resulting
  prompt (TRUE)

- prompt_build:

  Include the context and additional prompt as part of the request

- stream:

  To output the response from the LLM as it happens, or wait until the
  response is complete. Defaults to TRUE.

## Value

The output of the LLM to the console, document or script.

## Examples

``` r
library(chattr)
chattr_use("test")
#> 
#> ── chattr 
#> • Provider: test backend
#> • Model: Test model
#> • Label: Test
chattr("hello")
#> hello
chattr("hello", preview = TRUE)
#> hello
#> 
#> ── chattr ──────────────────────────────────────────────────────────────────────
#> 
#> ── Preview for: Console 
#> • Provider: test backend
#> • Model: Test model
#> • Label: Test
#> • n_predict: 1000
#> 
#> ── Prompt: 
```

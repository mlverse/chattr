# Displays and sets the current session' chat history

Displays and sets the current session' chat history

## Usage

``` r
ch_history(x = NULL)
```

## Arguments

- x:

  An list object that contains chat history. Use this argument to
  override the current history.

## Value

A list object with the current chat history

## Examples

``` r
library(chattr)

chattr_use("test", stream = FALSE)
#> 
#> ── chattr 
#> • Provider: test backend
#> • Model: Test model
#> • Label: Test

chattr("hello")
#> hello

# View history
ch_history()
#> 
#> ── Prompt: 
#> role: user
#> content: hello
#> role: assistant
#> content: hello

# Save history to a file
chat_file <- tempfile()
saveRDS(ch_history(), chat_file)

# Reset history
ch_history(list())
#> 
#> ── Prompt: 

# Re-load history
ch_history(readRDS(chat_file))
#> 
#> ── Prompt: 
#> role: user
#> content: hello
#> role: assistant
#> content: hello
```

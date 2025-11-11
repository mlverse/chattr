# Modify prompt enhancements

There are a lot of parameters that need to be set or sent when
communicating with the LLM. To reduce the complexity of every single
request, `chattr` processes and stores those parameters in an R object.
The object can be accessed via the function
[`chattr_defaults()`](https://mlverse.github.io/chattr/reference/chattr_defaults.md):

``` r
library(chattr)

chattr_use("ollama")
#> 
#> ── chattr
#> • Provider: Ollama
#> • Model: llama3.2
#> • Label: Llama 3.2 (Ollama)

chattr_defaults()
#> 
#> ── chattr ──────────────────────────────────────────────────────────────────────
#> 
#> ── Defaults for: Default ──
#> 
#> ── Prompt:
#> 
#> ── Model
#> • Provider: Ollama
#> • Model: llama3.2
#> • Label: Llama 3.2 (Ollama)
#> 
#> ── Context:
#> Max Data Files: 0
#> Max Data Frames: 0
#> ✖ Chat History
#> ✖ Document contents
```

**NOTE:** - For most users, this change will not work because accessing
GPT 4 via the REST API endpoints is currently restricted to a few
developers.

### Support for `glue`

The `prompt` argument supports `glue`. This means that you can pass
current values of variables, or current output from functions within
your current R session. Make sure that such output, or value, is a
character that is readable by the LLM.

Here is a simple example of a function that passes the variables
currently in your R session that contain “x”:

``` r
my_list <- function() {
  return(ls(pattern = "x", envir = globalenv()))
}
```

The `my_list()` function is passed to the `prompt` argument enclosed in
braces:

``` r
chattr_defaults(prompt = "{ my_list() }")
#> 
#> ── chattr ──────────────────────────────────────────────────────────────────────
#> 
#> ── Defaults for: Default ──
#> 
#> ── Prompt:
#> • {{ my_list() }}
#> 
#> ── Model
#> • Provider: Ollama
#> • Model: llama3.2
#> • Label: Llama 3.2 (Ollama)
#> 
#> ── Context:
#> Max Data Files: 0
#> Max Data Frames: 0
#> ✖ Chat History
#> ✖ Document contents
```

Now we can test it, by setting two variables that start with “x”

``` r
x1 <- 1
x2 <- 2
```

To see what will be sent to the LLM, you can use
`chattr(preview = TRUE)`. The two variables will be listed as part of
the prompt:

``` r
chattr(preview = TRUE)
#> 
#> ── chattr ──────────────────────────────────────────────────────────────────────
#> 
#> ── Preview for: Console
#> • Provider: Ollama
#> • Model: llama3.2
#> • Label: Llama 3.2 (Ollama)
#> 
#> ── Prompt:
```

We can see how the adding a new variable will modify the prompt with out
us having to modify
[`chattr_defaults()`](https://mlverse.github.io/chattr/reference/chattr_defaults.md):

``` r
x3 <- 3

chattr(preview = TRUE)
#> 
#> ── chattr ──────────────────────────────────────────────────────────────────────
#> 
#> ── Preview for: Console
#> • Provider: Ollama
#> • Model: llama3.2
#> • Label: Llama 3.2 (Ollama)
#> 
#> ── Prompt:
```

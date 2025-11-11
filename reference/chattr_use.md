# Sets the LLM model to use in your session

Sets the LLM model to use in your session

## Usage

``` r
chattr_use(x = NULL, ...)
```

## Arguments

- x:

  A pre-determined provider/model name, an `ellmer` `Chat` object, or
  the path to a YAML file that contains a valid `chattr` model
  specification. The value 'test' is also acceptable, but it is meant
  for package examples, and internal testing. See 'Details' for more
  information.

- ...:

  Default values to modify.

## Value

It returns console messages to allow the user select the model to use.

## Details

The valid pre-determined provider/models values are: 'databricks-dbrx',
'databricks-meta-llama31-70b', 'databricks-mixtral8x7b', 'gpt41-mini',
'gpt41-nano', 'gpt41', 'gpt4o', and 'ollama'.

If you need a provider, or model, not available as a pre-determined
value, create an `ellmer` chat object and pass that to `chattr_use()`.
The list of valid models are found here:
https://ellmer.tidyverse.org/index.html#providers

### Set a default

You can setup an R `option` to designate a default provider/model
connection. To do this, pass an `ellmer` connection command you wish to
use in the `.chattr_chat` option, for example:
`options(.chattr_chat = ellmer::chat_anthropic())`. If you add that code
to your *.Rprofile*, `chattr` will use that as the default model and
settings to use every time you start an R session. Use the
`usethis::edit_r_profile()` command to easily edit your *.Rprofile*.

## Examples

``` r
if (FALSE) { # \dontrun{

# Use a valid provider/model label
chattr_use("gpt41-mini")

# Pass an `ellmer` object
my_chat <- ellmer::chat_anthropic()
chattr_use(my_chat)
} # }
```

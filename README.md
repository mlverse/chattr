# tidychat

<!-- badges: start -->

[![R-CMD-check](https://github.com/edgararuiz/tidychat/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/edgararuiz/tidychat/actions/workflows/R-CMD-check.yaml)
[![Codecov test
coverage](https://codecov.io/gh/edgararuiz/tidychat/branch/main/graph/badge.svg)](https://app.codecov.io/gh/edgararuiz/tidychat?branch=main)
[![CRAN
status](https://www.r-pkg.org/badges/version/tidychat.png)](https://CRAN.R-project.org/package=tidychat)
[![](man/figures/lifecycle-experimental.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)

<!-- badges: end -->
<!-- toc: start -->

-   [Install](#install)
-   [Getting Started](#getting-started)
-   [Usage](#usage)
    -   [Use with `tidychat_app()`](#use-with-%60tidychat_app()%60)
-   [Appendix](#appendix)
    -   [How to setup the keyboard
        shortcut](#how-to-setup-the-keyboard-shortcut)

<!-- toc: end -->

## Install

Since this is a very early version of the package, you can either clone
the repo, or install the package from GH:

``` r
remotes::install_github("edgararuiz/tidychat")
```

## Getting Started

OpenAI requires a secret key to authenticate your user. It is required
for any application non-OpenAI application, such as `tidychat`, to have
one in order to function. A key is a long alphanumeric sequence. The
sequence is created in the OpenAI portal. To obtain your secret key, go
to: [OpenAI API Keys](https://platform.openai.com/account/api-keys)

By default, `tidychat` will look for the key inside the a Environment
Variable called `OPENAI_API_KEY`. Other packages that integrate with
OpenAI use the same variable name.

Use `Sys.setenv()` to set the variable. The downside of using this
method is that the variable will only be available during the current R
session:

``` r
Sys.setenv("OPENAI_API_KEY" = "####################")
```

So that the key is always available in your R session, create or add the
line to the `.Renviron` file. This file is available in your home
directory.

    OPENAI_API_KEY=####################

### First time

    library(tidychat)

    tidychat("How do I use facets")

    To use facets in ggplot2, you can use the `facet_wrap()` or `facet_grid()` 
    functions. 
        
    `facet_wrap()` creates a set of small multiples by wrapping a single plot 
    over a specified number of rows and columns. 
        
    `facet_grid()` creates a set of small multiples by splitting the plot into 
    a grid of rows and columns based on one or two variables.

## Usage

### Use with `tidychat_app()`

``` r
tidychat::tidychat_app()
```

    Show in New Window
    • Provider: Open AI
    • Model: GPT 3.5 Turbo
    Loading required package: shiny

    Listening on http://127.0.0.1:5253

## Appendix

### How to setup the keyboard shortcut

-   Select *Tools* in the top menu, and then select *Modify Keyboard
    Shortcuts*
    <img src="man/figures/readme/keyboard-shortcuts.png" width="600" />

-   Search for the `tidychat` adding by writing “open chat”, in the
    search box
    <img src="man/figures/readme/addin-find.png" width="500"/>

-   To select a key combination for your shortcut, click on the Shortcut
    box and then type *press* the key combination in your keyboard. In
    my case, I chose *Ctrl+Shift+C*
    <img src="man/figures/readme/addin-assign.png" width="500" />

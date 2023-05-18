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
    -   [Secret key](#secret-key)
    -   [Test connection](#test-connection)
-   [Usage](#usage)
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

### Secret key

OpenAI requires a **secret key** to authenticate your user. It is
required for any application non-OpenAI application, such as `tidychat`,
to have one in order to function. A key is a long alphanumeric sequence.
The sequence is created in the OpenAI portal. To obtain your **secret
key**, follow this link: [OpenAI API
Keys](https://platform.openai.com/account/api-keys)

By default, `tidychat` will look for the **secret key** inside the a
Environment Variable called `OPENAI_API_KEY`. Other packages that
integrate with OpenAI use the same variable name.

Use `Sys.setenv()` to set the variable. The downside of using this
method is that the variable will only be available during the current R
session:

``` r
Sys.setenv("OPENAI_API_KEY" = "####################")
```

A preferred method is to save the secret key to the `.Renviron` file.
This way, there is no need to load the environment variable every time
you start a new R session. The `.Renviron` file is available in your
home directory. Here is an example of the entry:

    OPENAI_API_KEY=####################

### Test connection

``` r
tidychat_test()
✔ Connection with OpenAI cofirmed
✔ Access to models confirmed
```

## Usage

![](man/figures/readme/chat1.png)

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

    <img src="man/figures/readme/keyboard-shortcuts.png" width="800" />

-   Search for the `tidychat` adding by writing “open chat”, in the
    search box

    <img src="man/figures/readme/addin-find.png" width="500" />

-   To select a key combination for your shortcut, click on the Shortcut
    box and then type *press* the key combination in your keyboard. In
    my case, I chose *Ctrl+Shift+C*

    <img src="man/figures/readme/addin-assign.png" width="600" />

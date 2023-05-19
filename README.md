# chattr

<!-- badges: start -->

[![R-CMD-check](https://github.com/edgararuiz/chattr/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/edgararuiz/chattr/actions/workflows/R-CMD-check.yaml)
[![Codecov test
coverage](https://codecov.io/gh/edgararuiz/chattr/branch/main/graph/badge.svg)](https://app.codecov.io/gh/edgararuiz/chattr?branch=main)
[![CRAN
status](https://www.r-pkg.org/badges/version/chattr.png)](https://CRAN.R-project.org/package=chattr)
[![](man/figures/lifecycle-experimental.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)

![](man/readme/chattr.gif)

<!-- badges: end -->
<!-- toc: start -->

-   [Install](#install)
-   [Getting Started](#getting-started)
    -   [Secret key](#secret-key)
    -   [Test connection](#test-connection)
-   [Using](#using)
    -   [The App](#the-app)
    -   [Keyboard Shortcut](#keyboard-shortcut)
-   [Appendix](#appendix)
    -   [How to setup the keyboard
        shortcut](#how-to-setup-the-keyboard-shortcut)

<!-- toc: end -->

## Install

Since this is a very early version of the package, you can either clone
the repo, or install the package from GH:

``` r
remotes::install_github("edgararuiz/chattr")
```

## Getting Started

### Secret key

OpenAI requires a **secret key** to authenticate your user. It is
required for any application non-OpenAI application, such as `chattr`,
to have one in order to function. A key is a long alphanumeric sequence.
The sequence is created in the OpenAI portal. To obtain your **secret
key**, follow this link: [OpenAI API
Keys](https://platform.openai.com/account/api-keys)

By default, `chattr` will look for the **secret key** inside the a
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

Use the `chattr_test()` function to confirm that your connection works:

``` r
chattr_test()
✔ Connection with OpenAI cofirmed
✔ Access to models confirmed
```

## Using

### The App

The main way to use `chattr` is through the Shiny Gadget app. By
default, it runs inside the Viewer pane. The fastest way to activate the
app is by calling it via the provided function:

``` r
chattr::chattr_app()
```

![](man/figures/readme/chat1.png)

A lot of effort was put in to make the app’s appearance as close as
possible to the IDE. This way it feels more integrated with your work
space. This includes switching the color scheme based on the current
RStudio theme being light, or dark.

Automatically, the app will automatically add buttons to each code
section. The buttons lets us copy the code to the clipboard, or to send
it to the document. If you [“call”](#keyboard-shortcut) the app from a
Quarto document, the app will envelop the code inside a chunk.

### Keyboard Shortcut

The best way to access `chattr`’s app is by setting up a keyboard
shortcut for it. This package includes an RStudio Addin that gives us
direct access to the app, which in turn, allows a **keyboard shortcut**
to be assigned to the addin. The name of the addin is: “Open Chat”. If
you are not familiar with how to assign a keyboard shortcut to the
adding see the Appendix section: [How to setup the keyboard
shortcut](#how-to-setup-the-keyboard-shortcut).

## Appendix

### How to setup the keyboard shortcut

-   Select *Tools* in the top menu, and then select *Modify Keyboard
    Shortcuts*

    <img src="man/figures/readme/keyboard-shortcuts.png" width="800" />

-   Search for the `chattr` adding by writing “open chat”, in the search
    box

    <img src="man/figures/readme/addin-find.png" width="500" />

-   To select a key combination for your shortcut, click on the Shortcut
    box and then type *press* the key combination in your keyboard. In
    my case, I chose *Ctrl+Shift+C*

    <img src="man/figures/readme/addin-assign.png" width="600" />

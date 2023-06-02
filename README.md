# chattr

<!-- badges: start -->

[![R-CMD-check](https://github.com/edgararuiz/chattr/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/edgararuiz/chattr/actions/workflows/R-CMD-check.yaml)
[![Codecov test
coverage](https://codecov.io/gh/edgararuiz/chattr/branch/main/graph/badge.svg)](https://app.codecov.io/gh/edgararuiz/chattr?branch=main)
[![CRAN
status](https://www.r-pkg.org/badges/version/chattr.png)](https://CRAN.R-project.org/package=chattr)
[![](man/figures/lifecycle-experimental.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)

<!-- badges: end -->

![](man/figures/readme/chattr.gif)

<!-- toc: start -->

-   [Intro](#intro)
-   [Available models](#available-models)
-   [Install](#install)
-   [Using](#using)
    -   [The App](#the-app)
    -   [Keyboard Shortcut](#keyboard-shortcut)
-   [How it works](#how-it-works)
-   [Appendix](#appendix)
    -   [How to setup the keyboard
        shortcut](#how-to-setup-the-keyboard-shortcut)

<!-- toc: end -->

## Intro

`chattr` is an interface to LLMs (Large Language Models). It enables
interaction with the model directly from the RStudio IDE. `chattr`
allows you to submit a prompt to the LLM from your script, or by using
the provided Shiny Gadget.

`chattr`’s main goal is to aid in EDA tasks. The additional information
appended to your request, provides a sort of “guard rails”, so that the
packages and techniques we usually recommend as best practice, are used
in the model’s responses.

## Available models

`chattr` provides two main integration with two main LLM back-ends. Each
back-end provides access to multiple LLM types:

<table>
<colgroup>
<col style="width: 25%" />
<col style="width: 48%" />
<col style="width: 25%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: center;">Provider</th>
<th style="text-align: center;">Models</th>
<th style="text-align: center;">Setup Instructions</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: center;"><a
href="https://platform.openai.com/docs/introduction">OpenAI</a></td>
<td style="text-align: center;">GPT Models accessible via the OpenAI’s
REST API. <code>chattr</code> provides a convenient way to interact with
GPT 3.5, and DaVinci 3.</td>
<td style="text-align: center;"><a
href="https://mlverse.github.io/chattr/articles/openai-gpt.html">Interact
with OpenAI GPT models</a></td>
</tr>
<tr class="even">
<td style="text-align: center;"><a
href="https://github.com/kuvaus/LlamaGPTJ-chat">LLamaGPT-Chat</a></td>
<td style="text-align: center;">LLM models available in your computer.
Including GPT-J, LLaMA, and MPT. Tested on a <a
href="https://gpt4all.io/index.html">GPT4ALL</a> model.
<strong>LLamaGPT-Chat</strong> is a command line chat program for models
written in C++.</td>
<td style="text-align: center;"><a
href="https://mlverse.github.io/chattr/articles/backend-llamagpt.html">Interact
with local models</a></td>
</tr>
</tbody>
</table>

The idea is that as time goes by, more back-ends will be added.

## Install

Since this is a very early version of the package install the package
from Github:

``` r
remotes::install_github("edgararuiz/chattr")
```

## Using

### The App

The main way to use `chattr` is through the Shiny Gadget app. By
default, it runs inside the Viewer pane. The fastest way to activate the
app is by calling it via the provided function:

``` r
chattr::chattr_app()
```

![Screenshot of the Sniny gadget app in a dark mode RStudio
theme](man/figures/readme/chat1.png)

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

## How it works

`chattr` enriches your request with additional instructions, name and
structure of data frames currently in your environment, the path for the
data files in your working directory. If supported by the model,
`chattr` will include the current chat history.

![Diagram that illustrates how chattr handles model
requests](man/figures/readme/chattr-diagram.png)

To see what `chattr` will send to the model, set the `preview` argument
to `TRUE`:

``` r
library(chattr)

data(mtcars)
data(iris)

chattr(preview = TRUE)
#> 
#> ── chattr ──────────────────────────────────────────────────────────────────────
#> 
#> ── Preview for: Console
#> • Provider: Open AI - Chat Completions
#> • Path/URL: https://api.openai.com/v1/chat/completions
#> • Model: gpt-3.5-turbo
#> • temperature: 0.01
#> • max_tokens: 1000
#> • stream: TRUE
#> 
#> ── Prompt:
#> role: system
#> content: You are a helpful coding assistant
#> role: user
#> content:
#> * Use the 'Tidy Modeling with R' (https://www.tmwr.org/) book as main reference
#> * Use the 'R for Data Science' (https://r4ds.had.co.nz/) book as main reference
#> * Use tidyverse packages: readr, ggplot2, dplyr, tidyr
#> * For models, use tidymodels packages: recipes, parsnip, yardstick, workflows,
#> broom
#> * Avoid explanations unless requested by user, expecting code only
#> [Your future prompt goes here]
```

## Appendix

### How to setup the keyboard shortcut

-   Select *Tools* in the top menu, and then select *Modify Keyboard
    Shortcuts*

    <img src="man/figures/readme/keyboard-shortcuts.png" width="700"
    alt="Screenshot that shows where to find the option to modify the keyboard shortcuts" />

-   Search for the `chattr` adding by writing “open chat”, in the search
    box

    <img src="man/figures/readme/addin-find.png" width="500"
    alt="Screenshot that shows where to input the addin search" />

-   To select a key combination for your shortcut, click on the Shortcut
    box and then type *press* the key combination in your keyboard. In
    my case, I chose *Ctrl+Shift+C*

    <img src="man/figures/readme/addin-assign.png" width="500"
    alt="Screenshot that shows what the interface looks like when a shortcut has been selected" />

tidychat
================

## Approach

This package is a prototype to see how we could integrate LLM into the
analyst workflow, by having it perform EDA tasks.

`tidychat`’s approach is to make it easy to test multiple LLM’s in the
back end,by separating the integration with a given API, from the UI of
this package.

This package also provides a flexible way to view and customize the
prompts being sent to the LLM.

At this time, only the OpenAI API is supported. And within that API,
there are two major internal functions that communicate with this API.
The first one is the API “Chat Completion” which is only available for
GPT 3.5 or above. The other is for “Completion”, which is used for the
“lower” OpenAI models, such as DaVinci and Ada. Switching between the
two is as simple as changing the default of the `model` argument from
`gpt3.5-turbo` to `text-davinci-003`, for example. `tidychat` will take
care of switching between the two OpenAI endpoints (Completion or Chat
Completion) seamlessly.

## Install

Since this is a very early version of the package, you can either clone
the repo, or install the package from GH:

``` r
remotes::install_github("edgararuiz/tidychat")
```

## Use

At this time, development has been focused on using LLM with a Quarto
document. To best use try the current mechanics out, install the
`tidychat`, and then bind the **Execute Prompt** addin (included in
`tidychat`) to an available key shortcut.

``` r
library(tidychat)
```

In a Quarto document, you can write the prompt to the LLM as a regular
line. When the addin is executed, `tidychat` assumes that the last line
in the document is the desired prompt, and will construct the final
prompt as that.

For example, this is the last line in this document

``` markdown
- Use the 'Tidy Modeling with R' (https://www.tmwr.org/) book as main reference 
- Use the 'R for Data Science' (https://r4ds.had.co.nz/) book as main reference 
- Use tidyverse packages: readr, ggplot2, dplyr, tidyr 
- skimr and janitor can also be used if needed 
- For models, use tidymodels packages: recipes, parsnip, yardstick, workflows, broom 
- Expecting only code, avoid comments unless requested by user 
- Data files available:  inst/test/data/county-hospital.csv 
- Current code: 
 ```{r} 
 remotes::install_github("edgararuiz/tidychat") 
```

```` markdown
```{r}
library(tidychat) 
```
````

------------------------------------------------------------------------

For example, this is the last line in this document \`\`\`

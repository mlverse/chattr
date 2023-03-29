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

Please refer to the video I shared on Slack to see how to use it.

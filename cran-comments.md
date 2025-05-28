## Pakcage Submission

* Switches to `ellmer` for all integration with the LLMs. This effectively 
removes any direct integration such as that one used for OpenAI, Databricks
and LlamaGPT-chat. It will now only integrate with whatever backend
`ellmer` integrates with.

* Shiny app now uses the stream from functionality from `ellmer` instead of the
more complex, and error prone, background process.

## R CMD check environments

- Mac OS M3 (aarch64-apple-darwin23), R 4.4.1 (Local)

- Mac OS x86_64-apple-darwin20.0 (64-bit), R 4.5.0 (GH Actions)
- Windows x86_64-w64-mingw32 (64-bit), R 4.5.0 (GH Actions)
- Linux x86_64-pc-linux-gnu (64-bit), R 4.5.0 (GH Actions)
- Linux x86_64-pc-linux-gnu (64-bit), (dev) (GH Actions)
- Linux x86_64-pc-linux-gnu (64-bit), R 4.4.3 (old release) (GH Actions)

## R CMD check results

0 errors ✔ | 0 warnings ✔ | 0 notes ✔

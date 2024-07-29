## Pakcage Submission

* Fixes how it identifies the user's current UI (console, app, notebook) and
appropriately outputs the response from the model end-point (#92)

* Adding support for Databricks foundation model API (DBRX, Meta Llama 3 70B,
Mixtral 8x7B) (#99)

* Fixes how it displays error from the model end-point when being used in a 
notebook or the app for OpenAI

* Fixes how the errors from OpenAI are parsed and processed. This should make
it easier for users to determine where an downstream issue could be.

* Adds `model` to defaults for Copilot

* Improves Copilot token discovery 

## R CMD check environments

- Mac OS M3 (aarch64-apple-darwin23), R 4.4.1 (Local)

- Mac OS x86_64-apple-darwin20.0 (64-bit), R 4.4.1 (GH Actions)
- Windows x86_64-w64-mingw32 (64-bit), R 4.4.1 (GH Actions)
- Linux x86_64-pc-linux-gnu (64-bit), R 4.4.1 (GH Actions)
- Linux x86_64-pc-linux-gnu (64-bit), (dev) (GH Actions)
- Linux x86_64-pc-linux-gnu (64-bit), R 4.3.3 (old release) (GH Actions)

## R CMD check results

0 errors ✔ | 0 warnings ✔ | 0 notes ✔

# chattr (dev)

## General

* Adds Ollama interface

* Fixes how it identifies the user's current UI (console, app, notebook) and
appropriately outputs the response from the model end-point (#92)

## OpenAI

* Fixes how it displays error from the model end-point when being used in a 
notebook or the app

* Fixes how the errors from OpenAI are parsed and processed. This should make
it easier for users to determine where an downstream issue could be.

# chattr 0.1.0

* Initial CRAN submission.

# Saves the current defaults in a yaml file that is compatible with the config package

Saves the current defaults in a yaml file that is compatible with the
config package

## Usage

``` r
chattr_defaults_save(path = "chattr.yml", overwrite = FALSE, type = NULL)
```

## Arguments

- path:

  Path to the file to save the configuration to

- overwrite:

  Indicates to replace the file if it exists

- type:

  The type of UI to save the defaults for. It defaults to NULL which
  will save whatever types had been used during the current R session

## Value

It creates a YAML file with the defaults set in the current R session.

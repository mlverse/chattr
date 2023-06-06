data(mtcars)
data(iris)


test_chattr_type_unset <- function() {
  Sys.unsetenv("CHATTR_TYPE")
}

test_chattr_type_set <- function(type) {
  Sys.setenv("CHATTR_TYPE" = type)
}

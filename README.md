## Open the project
Open the project using the .Rproj file

## Install required packages
The project use `renv` to manage packages needed. On an initial download use:

```
renv::restore()
```

to install the required packages

## Installing Quarto extensions
Within the project directory install the following extensions in the terminal

`quarto add coatless/quarto-webr`

`quarto add quarto-ext/shinylive`
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

### Adding a Shinylive object


### Adding a webr object

```
---
engine: knitr
filters:
  - webr
---

This is a webR-enabled code cell in a Quarto HTML document.

```{webr-r}
fit = lm(mpg ~ am, data = mtcars)

summary(fit)
\`\`\`

```

For cell-options
https://quarto-webr.thecoatlessprofessor.com/qwebr-cell-options.html 

## Updating the public version of the book

`quarto publish`







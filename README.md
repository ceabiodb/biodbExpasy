# biodbExpasy

An R package for accessing Expasy ENZYME database, based on R
package/framework [biodb](https://github.com/pkrog/biodb/).

## Introduction

This package is an extension of [biodb](https://github.com/pkrog/biodb/) that
implements a connector to Expasy ENZYME database.

## Installation

Install the latest version of this package by running the following commands:
```r
if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")
BiocManager::install('biodb')
devtools::install_github('pkrog/biodbExpasy', dependencies=TRUE)
```

## Examples

To instantiate a connector to Expasy ENZYME database., run:
```r
mybiodb <- biodb::newInst()
conn <- mybiodb$getFactory()$createConn('expasy.enzyme')
mybiodb$terminate()
```

## Documentation

To get documentation on the implemented connector, run the following command in
R:
```r
?biodbExpasy::ExpasyEnzymeConn
```

## Citations

<https://enzyme.expasy.org>

 * Bairoch A. The ENZYME database in 2000. Nucleic Acids Res 28:304-305(2000), <https://enzyme.expasy.org/data/enz00.pdf>.


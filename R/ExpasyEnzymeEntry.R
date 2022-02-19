#' Expasy ENZYME database. entry class.
#'
#' Entry class for Expasy ENZYME database.
#'
#' @seealso
#' \code{\link{BiodbTxtEntry}}.
#'
#' @examples
#' # Create an instance with default settings:
#' mybiodb <- biodb::newInst()
#'
#' # Get a connector that inherits from ExpasyEnzymeConn:
#' conn <- mybiodb$getFactory()$createConn('expasy.enzyme')
#'
#' # Get the first entry
#' e <- conn$getEntry('1.1.1.1')
#'
#' # Terminate instance.
#' mybiodb$terminate()
#'
#' @import biodb
#' @import R6
#' @export
ExpasyEnzymeEntry <- R6::R6Class("ExpasyEnzymeEntry",
    inherit=
        biodb::BiodbTxtEntry
    ,

public=list(

initialize=function(...) {
    super$initialize(...)
}

,doParseFieldsStep2=function(parsed.content) {

    # Cofactors may be listed on a single line, separated by a semicolon.
    if (self$hasField('COFACTOR')) {
        v <- unlist(strsplit(self$getFieldValue('COFACTOR'), ' *; *'))
        self$setFieldValue('COFACTOR', v)
    }

    # Synonyms
    g <- stringr::str_match(parsed.content, "^AN\\s+(.+?)\\.?$")
    results <- g[ ! is.na(g[,1]), , drop=FALSE]
    if (nrow(results) > 0)
        self$appendFieldValue('name', results[,2])
    
))

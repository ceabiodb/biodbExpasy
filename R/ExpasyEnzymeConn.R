#' Expasy ENZYME database. connector class.
#'
#' Connector class for Expasy ENZYME database.
#'
#' This is a concrete connector class. It must never be instantiated directly,
#' but instead be instantiated through the factory \code{\link{BiodbFactory}}.
#' Only specific methods are described here. See super classes for the
#' description of inherited methods.
#'
#' @seealso \code{\link{BiodbConn}}.
#'
#' @examples
#' # Create an instance with default settings:
#' mybiodb <- biodb::newInst()
#'
#' # Get a connector:
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
ExpasyEnzymeConn <- R6::R6Class("ExpasyEnzymeConn",
inherit=biodb::BiodbConn,

public=list(

#' @description
#' New instance initializer. Connector classes must not be instantiated
#' directly. Instead, you must use the createConn() method of the factory class.
#' @param ... All parameters are passed to the super class initializer.
#' @return Nothing.
initialize=function(...) {
    super$initialize(...)
}

#' @description
#' Calls enzyme-byname web service and returns the HTML result. See
#' http://enzyme.expasy.org/enzyme-byname.html.
#' @param name The name to search for.
#' @param retfmt The format to use for the returned value. 'plain' will return
#' the raw result from the server, as a character value. 'request' will return
#' a BiodbRequest instance containing the request as it would have been sent.
#' 'parsed' will return an XML object, containing the parsed result. 'ids' will
#' return a character vector containing the IDs of the matching entries.
#' @return Depending on `retfmt`.
,wsEnzymeByName=function(name, retfmt=c('plain', 'request', 'parsed', 'ids')) {

    retfmt <- match.arg(retfmt)

    # Build request
    burl <- biodb::BiodbUrl$new(url=c(self$getPropValSlot('urls', 'base.url'),
        "enzyme-byname.html"), params=name)
    request <- self$makeRequest(method='get', url=burl)
    if (retfmt == 'request')
        return(request)

    # Send request
    results <- self$getBiodb()$getRequestScheduler()$sendRequest(request)

    # Parse HTML
    results <- private$parseWsReturnedHtml(results=results, retfmt=retfmt)

    return(results)
}

#' @description
#' Calls enzyme-bycomment web service and returns the HTML result. See
#' http://enzyme.expasy.org/enzyme-bycomment.html.
#' @param comment The comment to search for.
#' @param retfmt The format to use for the returned value. 'plain' will return
#' the raw result from the server, as a character value. 'request' will return
#' a BiodbRequest instance containing the request as it would have been sent.
#' 'parsed' will return an XML object, containing the parsed result. 'ids' will
#' return a character vector containing the IDs of the matching entries.
#' @return Depending on `retfmt`.
,wsEnzymeByComment=function(comment, retfmt=c('plain', 'request', 'parsed',
    'ids')) {

    retfmt <- match.arg(retfmt)

    # Build request
    burl <- biodb::BiodbUrl$new(url=c(self$getPropValSlot('urls', 'base.url'),
        "enzyme-bycomment.html"), params=comment)
    request <- self$makeRequest(method='get', url=burl)
    if (retfmt == 'request')
        return(request)

    # Send request
    results <- self$getBiodb()$getRequestScheduler()$sendRequest(request)

    # Parse HTML
    results <- private$parseWsReturnedHtml(results=results, retfmt=retfmt)

    return(results)
}
),

private=list(

parseWsReturnedHtml=function(results, retfmt) {

    if (retfmt %in% c('parsed', 'ids')) {

        # Parse HTML
        results <- XML::htmlTreeParse(results, asText=TRUE,
            useInternalNodes=TRUE)

        # Get ids
        if (retfmt == 'ids')
            results <- XML::xpathSApply(results,
                "//a[starts-with(@href,'/EC/')]", XML::xmlValue)
    }

    return(results)
}

,doGetEntryIds=function(max.results=NA_integer_) {
    ids <- self$wsEnzymeByComment('e', retfmt='ids')
    return(ids)
}

,doSearchForEntries=function(fields=NULL, max.results=NA_integer_) {

    ids <- character()

    if ( ! is.null(fields)) {

        # Search by name
        if ('name' %in% names(fields))
            ids <- self$wsEnzymeByName(name=fields$name, retfmt='ids')
    }
    
    return(ids)
}

,doGetEntryContentRequest=function(id, concatenate=TRUE) {

    fct <- function(x) {
        u <- c(self$getPropValSlot('urls', 'base.url'), 'EC',
               paste(x, 'txt', sep='.'))
        return(biodb::BiodbUrl$new(url=u)$toString())
    }
    urls <- vapply(id, fct, FUN.VALUE='')

    return(urls)
}

,doGetEntryPageUrl=function(id) {

    urls <- rep(NA_character_, length(id))

    # Loop on all IDs
    i <- 0
    for (x in id) {

        i <- i + 1

        # Get four fields of ID
        fields <- strsplit(x, '\\.')[[1]]
        if (length(fields) == 4) {
            u <- c(self$getPropValSlot('urls', 'base.url'), 'cgi-bin',
                   'enzyme', 'enzyme-search-ec')
            p <- list(field1=fields[[1]], field2=fields[[2]],
                      field3=fields[[3]], field4=fields[[4]])
            urls[[i]] <- biodb::BiodbUrl$new(url=u, params=p)$toString()
        }
    }

    return(urls)
}

,doGetEntryImageUrl=function(id) {

    # TODO Modify this code to build the individual URLs to the entry images 
    fct <- function(x) {
        u <- c(self$getPropValSlot('urls', 'base.url'), 'images', x,
               'image.png')
        BiodbUrl$new(url=u)$toString()
    }

    return(vapply(id, fct, FUN.VALUE=''))
}
))

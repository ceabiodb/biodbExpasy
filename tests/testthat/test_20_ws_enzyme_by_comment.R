# vi: fdm=marker ts=4 et cc=80 tw=80

# Set context
testthat::context("Test enzyme-bycomment web service.")

# Run test
testthat::test_that('Calls to enzyme-bycomment ExPASy Enzyme web service work fine.', {

    # Instantiate Biodb
    biodb <- biodb::createBiodbTestInstance()

    # Create connector
    conn <- biodb$getFactory()$createConn('expasy.enzyme')

    ids <- conn$wsEnzymeByComment("best", retfmt = 'ids')

    expect_gt(length(ids), 0)
    expect_equal(length(grep('^[0-9.]*$', ids)), length(ids))

    # Terminate Biodb
    biodb$terminate()
})

test_wsEnzymeByName <- function(conn) {
    
    ids <- conn$wsEnzymeByName("Alcohol", retfmt = 'ids')

    expect_gt(length(ids), 0)
    expect_equal(length(grep('^[0-9.]*$', ids)), length(ids))
}

test_wsEnzymeByComment <- function(conn) {

    ids <- conn$wsEnzymeByComment("best", retfmt = 'ids')

    expect_gt(length(ids), 0)
    expect_equal(length(grep('^[0-9.]*$', ids)), length(ids))
}

# Set test context
biodb::testContext("Example tests")

# Instantiate Biodb
biodb <- biodb::createBiodbTestInstance(ack=TRUE)

# Load package definitions
defFile <- system.file("definitions.yml", package='biodbExpasy')
biodb$loadDefinitions(defFile)

# Create connector
conn <- biodb$getFactory()$createConn('expasy.enzyme')

# Run tests
biodb::testThat('enzymeByName web service works correctly.',
                test_wsEnzymeByName, conn=conn)
biodb::testThat('enzymeByComment web service works correctly.',
                test_wsEnzymeByComment, conn=conn)

# Terminate Biodb
biodb$terminate()

test_wsFind <- function(conn) {
    
    # Get request
    testthat::expect_is(conn$wsFind('aaa', retfmt='request'), 'BiodbRequest')
    
    # Get plain format
    testthat::expect_match(conn$wsFind('aaa', retfmt='plain'),
                           regexp="^\\{.*\\}$")
    
    # Get parsed format 
    testthat::expect_is(conn$wsFind('aaa', retfmt='parsed'), 'list')
    
    # Get IDs
    testthat::expect_is(conn$wsFind('aaa', retfmt='ids'), 'character')
}

# Set test context
biodb::testContext("Example long tests")

# Instantiate Biodb
biodb <- biodb::createBiodbTestInstance(ack=TRUE)

# Load package definitions
defFile <- system.file("definitions.yml", package='biodbExpasy')
biodb$loadDefinitions(defFile)

# Create connector
conn <- biodb$getFactory()$createConn('expasy.enzyme')

# Run tests
biodb::testThat('Find web service is well implemented.',
                test_wsFind, conn=conn)
# TODO Implement your own tests

# Terminate Biodb
biodb$terminate()

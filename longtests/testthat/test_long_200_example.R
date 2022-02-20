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
# TODO Implement your own tests

# Terminate Biodb
biodb$terminate()

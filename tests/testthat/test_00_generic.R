# vi: fdm=marker ts=4 et cc=80 tw=80

# Set context
testthat::context("Generic tests.")

# Instantiate Biodb
biodb <- biodb::createBiodbTestInstance()

# Create connector
conn <- biodb$getFactory()$createConn('expasy.enzyme')

# Run tests
biodb::runGenericTests(conn)

# Terminate Biodb
biodb$terminate()

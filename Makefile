# vi: fdm=marker

# Global variables {{{1
################################################################

# Mute R 3.6 "Registered S3 method overwritten" warning messages.
# Messages that were output:
#     Registered S3 method overwritten by 'R.oo':
#       method        from
#       throw.default R.methodsS3
#     Registered S3 method overwritten by 'openssl':
#       method      from
#       print.bytes Rcpp
export _R_S3_METHOD_REGISTRATION_NOTE_OVERWRITES_=no

# Set cache folder
ifndef BIODB_CACHE_DIRECTORY
export BIODB_CACHE_DIRECTORY=$(PWD)/cache
endif

# Set testthat reporter
ifndef TESTTHAT_REPORTER
ifdef VIM
TESTTHAT_REPORTER=summary
else
TESTTHAT_REPORTER=progress
endif
endif

PKG_VERSION=$(shell grep '^Version:' DESCRIPTION | sed 's/^Version: //')
ZIPPED_PKG=biodb_$(PKG_VERSION).tar.gz

RFLAGS=--slave --no-restore

# Default target {{{1
################################################################

all:

# Check and test {{{1
################################################################

check: $(ZIPPED_PKG)
	time R CMD check "$<"

bioc.check: $(ZIPPED_PKG)
	R $(RFLAGS) -e 'library(BiocCheck)' # Make sure library is loaded once in order to install the scripts.
	time R CMD BiocCheck --new-package --quit-with-status --no-check-formatting "$<"

test: check.version
	R $(RFLAGS) -e "devtools::test('$(CURDIR)', reporter = c('$(TESTTHAT_REPORTER)', 'fail'))"

win:
	R $(RFLAGS) -e "devtools::build_win('$(CURDIR)')"

# Build {{{1
################################################################

$(ZIPPED_PKG) build: doc
	R CMD build .

# Documentation {{{1
################################################################

doc:
	R $(RFLAGS) -e "devtools::document('$(CURDIR)')"

vignettes:
	@echo Build vignettes for already installed package, not from local soures.
	R $(RFLAGS) -e "devtools::clean_vignettes('$(CURDIR)')"
	time R $(RFLAGS) -e "devtools::build_vignettes('$(CURDIR)')"

# Install {{{1
################################################################

install.deps:
	R $(RFLAGS) -e "devtools::install_dev_deps('$(CURDIR)')"

install: uninstall install.local list.classes

install.local:
	R $(RFLAGS) -e "devtools::install_local('$(CURDIR)', dependencies = TRUE)"

list.classes:
	R $(RFLAGS) -e 'library(biodb) ; cat("Exported methods and classes:", paste(" ", ls("package:biodb"), collapse = "\n", sep = ""), sep = "\n")'

uninstall:
	R $(RFLAGS) -e "try(devtools::uninstall('$(CURDIR)'), silent = TRUE)"

# Clean {{{1
################################################################

clean: clean.build
	$(RM) -r tests/testthat/output
	$(RM) -r biodb.Rcheck

clean.build:
	$(RM) biodb_*.tar.gz

clean.cache:
	$(RM) -r $(BIODB_CACHE_DIRECTORY)

# Phony targets {{{1
################################################################

.PHONY: all clean win test build check vignettes install uninstall clean.build clean.cache doc

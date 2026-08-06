ROC ?= roc
ROC_CACHE_DIR ?= $(CURDIR)/.cache/roc
ROC_SOURCES := $(wildcard package/*.roc)
DIST_DIR ?= build/dist

.DEFAULT_GOAL := check

.PHONY: fmt fmt-check check test docs dist clean

fmt:
	$(ROC) fmt $(ROC_SOURCES)

fmt-check:
	$(ROC) fmt --check $(ROC_SOURCES)

check: fmt-check
	env ROC_CACHE_DIR=$(ROC_CACHE_DIR) $(ROC) check package/main.roc

test:
	env ROC_CACHE_DIR=$(ROC_CACHE_DIR) $(ROC) test package/main.roc

docs:
	env ROC_CACHE_DIR=$(ROC_CACHE_DIR) $(ROC) docs package/main.roc --output=build/docs

dist: check
	mkdir -p $(DIST_DIR)
	cd package && env ROC_CACHE_DIR=$(ROC_CACHE_DIR) $(ROC) bundle main.roc --output-dir $(abspath $(DIST_DIR))

clean:
	rm -rf build .cache

.PHONY: license
.PHONY: setup
.PHONY: ci cd
.PHONY: db run

MKFILE_PATH:=$(abspath $(lastword $(MAKEFILE_LIST)))
CURRENT_ABS_DIR:=$(patsubst %/,%,$(dir $(MKFILE_PATH)))

PROJECT_NAME:=notebook-report
DOCKER_NAME:=notebook-report

#################################################################################
# COMMANDS -- license                                                           #
#################################################################################
license: ## Verify source code license headers.
	./scripts/verify_license_headers.sh $(CURRENT_ABS_DIR)/src $(CURRENT_ABS_DIR)/tests

#################################################################################
# COMMANDS -- Setup                                                             #
#################################################################################
setup: clean install ## Setup the project

clean: clean-build clean-pyc ## Clean the project
	rm -rf venv/

clean-build: ## Clean build files
	rm -fr build/
	rm -fr dist/
	rm -fr .eggs/
	find . -name '*.egg-info' -exec rm -fr {} +
	find . -name '*.egg' -exec rm -fr {} +

clean-pyc: ## Clean cache files
	find . -name '*.pyc' -exec rm -f {} +
	find . -name '*.pyo' -exec rm -f {} +
	find . -name '*~' -exec rm -f {} +
	find . -name '__pycache__' -exec rm -fr {} +

build-req: clean ## Upgrade requirements
	test -f venv/bin/activate || python3.8 -m venv  $(CURRENT_ABS_DIR)/venv ;\
	. venv/bin/activate ;\
	pip install pip==20.1.1 ;\
	pip freeze | sort > requirements.txt

install: clean ## Install python virtrual environment
	test -f venv/bin/activate || python3.8 -m venv  $(CURRENT_ABS_DIR)/venv ;\
	. venv/bin/activate ;\
	pip install pip==20.1.1 ;\
	pip install -Ur requirements.txt

#################################################################################
# Self Documenting Commands                                                     #
#################################################################################
.PHONY: help

.DEFAULT_GOAL := help

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

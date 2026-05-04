.PHONY: setup validate package-plugin package-release

PYTHON ?= python3
VENV ?= .venv

setup:
	@if [ ! -x "$(VENV)/bin/python3" ]; then \
		echo "creating venv at $(VENV)"; \
		$(PYTHON) -m venv $(VENV); \
	fi
	$(VENV)/bin/pip install --quiet --upgrade pip
	$(VENV)/bin/pip install --quiet -r requirements.txt
	@echo "setup done. Run: PYTHON_BIN=$(VENV)/bin/python3 make validate"

validate:
	PYTHON_BIN=$${PYTHON_BIN:-$(VENV)/bin/python3} bash scripts/validate_all.sh

package-plugin:
	bash plugin/crafting-system/scripts/package-plugin.sh /tmp/crafting-system-plugin.zip

package-release:
	bash scripts/package_release.sh --out /tmp/crafting-kit-release.zip

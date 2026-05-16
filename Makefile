.PHONY: deps docs serve livehtml stop clean clean-venv

VENV := .venv
PY := $(VENV)/bin/python
PIP := $(VENV)/bin/pip
SPHINX_BUILD := $(VENV)/bin/sphinx-build
SPHINX_AUTOBUILD := $(VENV)/bin/sphinx-autobuild

# Create venv if missing, then install / upgrade dependencies from requirements.txt
deps: $(PY) requirements.txt
	$(PIP) install --upgrade pip
	$(PIP) install -r requirements.txt

$(PY):
	python3 -m venv $(VENV)

docs: deps
	$(SPHINX_BUILD) -b html docs docs/_build/html

serve: docs
	./scripts/serve_docs.sh

livehtml: deps
	$(SPHINX_AUTOBUILD) docs docs/_build/html --host 127.0.0.1 --port 8000

# Stop local preview: sphinx-autobuild and/or python http.server on port 8000
stop:
	@-pkill -f sphinx-autobuild 2>/dev/null || true
	@-if lsof -ti:8000 >/dev/null 2>&1; then kill -9 $$(lsof -ti:8000) 2>/dev/null; fi || true
	@echo "Stopped preview server (port 8000 / sphinx-autobuild) if it was running."

clean:
	rm -rf docs/_build

clean-venv:
	rm -rf $(VENV)

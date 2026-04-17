.PHONY: docs serve livehtml clean

docs:
	sphinx-build -b html docs docs/_build/html

serve: docs
	./scripts/serve_docs.sh

livehtml:
	sphinx-autobuild docs docs/_build/html --host 127.0.0.1 --port 8000

clean:
	rm -rf docs/_build

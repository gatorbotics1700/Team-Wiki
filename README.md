# Team Wiki

Sphinx documentation for FRC Team 1700 & 1854.

- **Live site:** https://gatorbotics1700.github.io/Team-Wiki/

## Make commands

From the repository root, `make` creates a `.venv` (if needed), installs Python dependencies from `requirements.txt`, and runs the matching tool inside that venv.

| Command | What it does |
|--------|----------------|
| `make deps` | Create `.venv` and run `pip install` / upgrade pip (only dependencies). |
| `make docs` | Dependencies + one-off HTML build to `docs/_build/html`. |
| `make livehtml` | Dependencies + **sphinx-autobuild** with live reload at http://127.0.0.1:8000 |
| `make serve` | Same as `make docs`, then a simple **HTTP server** on port 8000 for the built HTML (no auto-rebuild). |
| `make stop` | Stop **sphinx-autobuild** and anything listening on **port 8000** (e.g. `livehtml` or `serve`). |
| `make clean` | Remove `docs/_build/`. |
| `make clean-venv` | Remove `.venv/` (fresh install next time you run `make deps` or another target that needs deps). |

**Typical workflow**

```bash
make livehtml
# …edit docs, refresh browser…
make stop
```

## Local preview (manual venv, optional)

If you prefer to manage the venv yourself:

```bash
python3 -m venv .venv
source .venv/bin/activate   # Windows: .venv\Scripts\activate
pip install -r requirements.txt
make livehtml                 # or: .venv/bin/sphinx-autobuild docs docs/_build/html --host 127.0.0.1 --port 8000
```

Open http://127.0.0.1:8000

## Deploy

Push to `main`; the GitHub Actions workflow **Deploy docs to GitHub Pages** builds and publishes the site. In the repo **Settings → Pages**, set the source to **GitHub Actions** if it is not already.

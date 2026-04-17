# Team Wiki

Sphinx documentation for FRC Team 1700 & 1854.

- **Live site:** https://gatorbotics1700.github.io/Team-Wiki/ (after Pages is enabled and the first workflow run succeeds)

## Local preview

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
make livehtml
```

Open http://127.0.0.1:8000

## GitHub Pages (one-time setup)

1. Repository **Settings** → **Pages**
2. Under **Build and deployment**, set **Source** to **GitHub Actions**
3. Push to `main`; the workflow **Deploy docs to GitHub Pages** builds and publishes automatically

# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

Sphinx documentation site (reStructuredText) for FRC Team 1700 & 1854 — a knowledge-transfer wiki covering mechanisms, drivetrain, software, and season archives. There is no application code; this repo is content plus Sphinx build tooling. Live site: https://gatorbotics1700.github.io/Team-Wiki/

## Commands

All `make` targets auto-create a `.venv` and install `requirements.txt` before running.

- `make livehtml` — sphinx-autobuild with live reload at http://127.0.0.1:8000 (primary workflow when editing docs)
- `make docs` — one-off HTML build to `docs/_build/html`
- `make serve` — build, then serve `docs/_build/html` on port 8000 with no auto-rebuild
- `make stop` — kill sphinx-autobuild and anything on port 8000
- `make clean` — remove `docs/_build/`
- `make clean-venv` — remove `.venv/`
- `make deps` — create/refresh `.venv` only

Typical loop: `make livehtml`, edit files under `docs/`, browser auto-refreshes, `make stop` when done.

Deployment is automatic: pushing to `main` triggers `.github/workflows/deploy-docs.yml`, which builds with Sphinx and deploys to GitHub Pages. There is no manual deploy step and no build to run before pushing (though running `make docs` locally first will surface Sphinx errors before CI does).

## Architecture: how the sidebar and nav are controlled

The single most important thing to understand is that **`docs/index.rst` controls the sidebar structure**, not the filesystem layout.

- Each top-level sidebar section (Mechanisms, Drivetrain, Code, Season Archive, Contributing) corresponds to one `.. toctree::` block in `docs/index.rst`, with `:caption:` giving the section name shown in the sidebar. A page appears under whichever toctree lists it.
- To add a new top-level sidebar section, add a new `.. toctree::` block with its own `:caption:` in `docs/index.rst`.
- To nest a page under an existing page (e.g. Mechanisms → Intake → Intake (2026)) rather than at the top level, add it to that parent page's own `.. toctree::` instead of to `index.rst`. Example: `docs/mechanisms/index.rst` lists `climber`, `intake-pages/intake`, `shooter`; `docs/mechanisms/intake-pages/intake.rst` in turn lists `intake-2026` in its own toctree. This two-level pattern (hub page with a `toctree` + child pages) is how every mechanism category is organized — follow it for new mechanism families or new season-specific sub-pages.
- Toctree paths are relative to `docs/`, without the `.rst` extension.
- Order of toctree blocks in `index.rst` determines sidebar order (top to bottom); order of entries within a toctree determines order within that section.
- `docs/conf.py` sets `titles_only: False`, so a page's in-page headings (h2/h3 via `----`/`^^^^` underlines) also appear as an outline under that page's sidebar entry — get heading levels right, they affect nav, not just page display.

Full walkthrough with examples lives in [docs/editing-the-wiki.rst](docs/editing-the-wiki.rst) — read it before restructuring the sidebar.

## Content conventions

- Pages use reStructuredText, not Markdown. Headings use underline characters matching the title length (`===` for title, `---` for major section, `^^^` for subsection).
- `sphinx-design` is enabled (see `docs/conf.py`) and used for the card-grid landing pages (`index.rst`, `mechanisms/index.rst`) via `.. grid::` / `.. grid-item-card::` directives linking to child docs. Follow this pattern for new hub/index pages rather than plain bullet lists.
- Static assets (images, CSS) go under `docs/_static/`; e.g. mechanism images live in `docs/_static/images/<mechanism>/`.
- `docs/season-archive/season-template.rst` is a template to copy when starting a new season's archive page.
- Theme is `sphinx_rtd_theme`; `docs/_static/custom.css` holds site-specific style overrides.

import os

project = "FRC Team 1700 & 1854 Wiki"
author = "Gatorbotics"
copyright = "2026, Gatorbotics"

# Set in CI for GitHub Pages (project site under /Team-Wiki/).
_base = os.environ.get("SPHINX_HTML_BASEURL", "").rstrip("/")
html_baseurl = f"{_base}/" if _base else ""

extensions = ["sphinx_design"]

templates_path = ["_templates"]
exclude_patterns = ["_build", "Thumbs.db", ".DS_Store"]

html_theme = "sphinx_rtd_theme"
html_static_path = ["_static"]
html_css_files = ["custom.css"]
html_title = "FRC Team Docs"
html_theme_options = {
    # False = full nav stays visible; True often hides siblings and feels like an
    # older "flat" sidebar when you open mechanism pages.
    "collapse_navigation": False,
    "navigation_depth": 5,
    "includehidden": True,
    # False = sidebar shows this page's section headings (h2, h3, …) under the doc title.
    "titles_only": False,
}

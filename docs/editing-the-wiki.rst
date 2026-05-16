How to edit this wiki
=======================

This site is built with **Sphinx** from files under the ``docs/`` folder. What
you put in ``docs/index.rst`` controls which **sidebar section** each page
belongs to.

Which sidebar section a page appears in
-----------------------------------------

Each green sidebar block (for example **Mechanisms**, **Code**) comes from one
``.. toctree::`` block in ``docs/index.rst``. A page shows up under the block
that **lists** it.

Example from ``index.rst``:

.. code-block:: rst

   .. toctree::
      :maxdepth: 2
      :caption: Code

      software/index

To add a new page under **Code**, create ``docs/software/my-page.rst`` and add
``software/my-page`` to that same toctree (paths are relative to ``docs/``,
without ``.rst``).

To put a page under **Mechanisms** instead, add its line under the Mechanisms
``toctree``, not the Code one.

Add a new top-level sidebar section
-----------------------------------

Add a **new** ``.. toctree::`` in ``docs/index.rst`` with its own caption:

.. code-block:: rst

   .. toctree::
      :maxdepth: 2
      :caption: Your new section name

      path/to/first-page
      path/to/second-page

Order of these blocks in ``index.rst`` is the order they appear in the sidebar
(top to bottom).

Add a new page (minimal steps)
------------------------------

#. Create ``docs/<folder>/<name>.rst`` (or ``docs/<name>.rst`` at the top level).
#. Start with a title and underline (see the **Headings** section below).
#. Add ``<folder>/<name>`` (or ``<name>``) to the correct ``toctree`` in
   ``docs/index.rst``, or to a **parent** page’s toctree if it should nest under
   that page (like **Intake** → **Intake (2026)**).

Nested pages under one parent (example: Intake)
-----------------------------------------------

- ``docs/index.rst`` lists ``mechanisms/index`` under Mechanisms. That page is
  the **mechanisms hub** and lists climber, intake, shooter in its own
  ``toctree``.
- ``docs/mechanisms/intake-pages/intake.rst`` contains its own ``.. toctree::``
  listing ``intake-2026``, etc.

That makes **Mechanisms** → **Intake** → **Intake (2026)** in the nav.

Headings (in-page outline and sidebar)
--------------------------------------

Use underline characters; length should match the title text.

.. code-block:: rst

   Page title
   ==========

   Major section
   -------------

   Subsection
   ^^^^^^^^^^

With ``titles_only: False`` in ``docs/conf.py``, these headings can appear in
the sidebar as an outline for the **current** page.

Preview locally
---------------

From the repo root (with a venv and dependencies installed):

.. code-block:: bash

   make livehtml

Then open http://127.0.0.1:8000 . The site also deploys from ``main`` via
GitHub Actions when you push.

Further reading
---------------

- `reStructuredText primer <https://www.sphinx-doc.org/en/master/usage/restructuredtext/basics.html>`__
- `Sphinx toctree <https://www.sphinx-doc.org/en/master/usage/restructuredtext/directives.html#directive-toctree>`__

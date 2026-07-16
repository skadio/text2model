"""Text2Zinc dataset editor (flet GUI). Launched via `text2model --editor`.

Import of this subpackage is deliberately kept out of text2model/__init__.py
and text2model/main.py's module scope, so plain `--problem`/Text2Zinc-mode
invocations don't pay the cost of importing flet at startup; it's only
imported inside the `--editor` CLI branch.
"""
from text2model.editor.app import launch

__all__ = ["launch"]

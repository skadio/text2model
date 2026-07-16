"""Text2Zinc dataset editor (flet GUI). Launched via `text2model --editor`.

Import of this subpackage is deliberately kept out of text2model/__init__.py
and text2model/main.py's module scope: `flet` is an optional dependency
(`pip install text2model[editor]`), so `from text2model.editor import launch`
is only attempted inside the `--editor` CLI branch, where an ImportError can
be caught and reported with an actionable install hint.
"""
from text2model.editor.app import launch

__all__ = ["launch"]

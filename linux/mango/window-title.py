"""Expose Mango's focused window to Waybar without the DWL protocol."""
import html
import json
import subprocess

try:
    result = subprocess.run(
        ["mmsg", "get", "focusing-client"], capture_output=True, text=True,
        timeout=1, check=True,
    )
    title = json.loads(result.stdout).get("title", "")
    print(json.dumps({"text": html.escape(title), "tooltip": html.escape(title)}))
except (subprocess.SubprocessError, OSError, ValueError, AttributeError, TypeError):
    print(json.dumps({"text": "", "tooltip": ""}))

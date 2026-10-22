"""Focus an existing WezTerm window, or open one when none exists."""
import json
import subprocess


def ipc(*args):
    return subprocess.run(
        ["mmsg", *args], check=True, capture_output=True, text=True, timeout=3
    ).stdout


def main():
    clients = json.loads(ipc("get", "all-clients"))["clients"]
    terminals = [
        client for client in clients
        if client.get("appid", "").lower() in {"org.wezfurlong.wezterm", "wezterm"}
        and not client.get("is_swallowedby", False)
    ]
    if not terminals:
        subprocess.Popen(["wezterm", "start", "--always-new-process"])
        return
    # Prefer the focused terminal, then a visible one, then another tag.
    target = max(terminals, key=lambda c: (c.get("is_focused", False), c.get("is_visible", False)))
    if not target.get("is_visible", False) and target.get("tags"):
        ipc("dispatch", f"viewcrossmon,{target['tags'][0]},{target['monitor']}")
    ipc("dispatch", "focusid", f"client,{target['id']}")


if __name__ == "__main__":
    main()

#!/usr/bin/env bash
set -euo pipefail
# Compatibility entry point for the old Mint setup command.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
exec bash "$SCRIPT_DIR/go-mint.sh" "$@"

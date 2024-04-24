#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PATH="/usr/local/bin:$PATH:/usr/sbin"

main() {
  $(tmux bind-key -T prefix m run -b "source $CURRENT_DIR/scripts/dbus_spotify.sh && show_menu")
}

main

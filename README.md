# Spotify plugin for tmux
[![GitHub](https://img.shields.io/github/license/chrisgzlez/tmux-spotify-linux)](https://opensource.org/licenses/MIT)

This is a fork of the tmux-spotify plugin from xamut that used *dbus* instead of applescript for compatibility with linux.
Check the original source code and thanks for the inspiration on [xamut's GitHub repo](https://github.com/xamut/tmux-spotify)
This fork is located at [chrisgzlez/tmux-spotify-linux](https://github.com/chrisgzlez/tmux-spotify-linux)

## Installation
### Requirements
- Linux distro that supports DBus and has dbus and dbus-send cli utilities installed (every major Linux Distros)
- tmux >= 3.0

### With Tmux Plugin Manager
Add the plugin in `.tmux.conf`:
```
set -g @plugin 'chrisgzlez/tmux-spotify-linux'
```
Press `prefix + I` to fetch the plugin and source it. Done.

### Manual Installation
Clone the repo somewhere. Add `run-shell` in the end of `.tmux.conf`:

```
run-shell PATH_TO_REPO/tmux-spotify-linux.tmux
```
NOTE: this line should be placed at the end of the configuration file.

Relaunch Tmux:
- (Only for current session) Press `prefix + :` and type `source-file ~/.tmux.conf`
- Kill the tmux server: `prefix + :` and type `kill-server` or from the CLI `tmux kill-server` and open it again (sessions will be lost)

## Usage
Press tmux `prefix + m` and you will see the following menu:

> Note: If Spotify is not yet openend it will only provide the option to open it

```
- Open Spotify    (o) - open/launch Spotify
- Play/Pause      (p) - toggle play/pause
- Previous        (b) - play the current track from the beggining or play the previous track
- Next            (n) - play the next track
- Turn on repeat  (r) - Toggle Repeating Mode: None - Playlist - Track
- Turn on shuffle (s) - Toggle Shuffle Mode on/off
- Close menu      (q) - close menu
```

## License
tmux-spotify-linux plugin is released under the [MIT License](https://opensource.org/licenses/MIT).

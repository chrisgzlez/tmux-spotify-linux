# Spotify plugin for tmux
[![GitHub](https://img.shields.io/github/license/chrisgzlez/tmux-spotify-linux)](https://opensource.org/licenses/MIT)

This is a fork of the tmux-spotify plugin from xamut that used *dbus* instead of applescript for compatibility with linux.
Check the original source code and thanks for the inspiration on [xamut's GitHub repo](https://github.com/xamut/tmux-spotify)
This fork is located at [chrisgzlez/tmux-spotify-linux](https://github.com/chrisgzlez/tmux-spotify-linux)
<p align="center">
  <img src="https://github.com/chrisgzlez/tmux-spotify-linux/raw/main/media/full_spotify_menu.gif" alt="full-spotify-menu-display" width=70% height=100%>
</p>

## Installation
### Requirements
- Spotify
- Linux distro that supports DBus and has dbus-send cli utilities installed (every major Linux Distros)
- tmux >= 3.0

### With Tmux Plugin Manager
Add the plugin in `.tmux.conf`:
```bash
set -g @plugin 'chrisgzlez/tmux-spotify-linux'
```
Press `prefix + I` to fetch the plugin and source it. Done.

### Manual Installation
Clone the repo somewhere. Add `run-shell` in the end of `.tmux.conf`:

```javascript
run-shell PATH_TO_REPO/tmux-spotify-linux.tmux
```
NOTE: this line should be placed at the end of the configuration file.

Relaunch Tmux:
- (Only for current session) Press `prefix + :` and type `source-file ~/.tmux.conf`
- Kill the tmux server: `prefix + :` and type `kill-server` or from the CLI `tmux kill-server` and open it again (sessions will be lost)

## Usage
Press tmux `prefix + m` and you will see the following menu:

> Note: If Spotify is not yet openend it will only provide the option to open it

```javascript
- Open Spotify    (o) - Open/Launch Spotify
- Play/Pause      (p) - Toggle Play/Pause
- Previous        (b) - Play The Current Track From The Beggining Or Play The Previous Track
- Next            (n) - Play The Next Track
- Toggle Repeat   (r) - Toggle Repeating Mode: None - Playlist - Track
- Toggle shuffle  (s) - Toggle Shuffle Mode On/Off
- Close Menu      (q) - Close Menu
```

## License
tmux-spotify-linux plugin is released under the [MIT License](https://opensource.org/licenses/MIT).

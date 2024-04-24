#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PATH="/usr/local/bin:$PATH:/usr/sbin"

dbus_send_spotify() {
  dbus-send --session \
      --dest=org.mpris.MediaPlayer2.spotify \
      --type=method_call \
      /org/mpris/MediaPlayer2 \
      org.mpris.MediaPlayer2.Player.${1}
}

dbus_set_spotify() {
  property=${1}
  value_type=${2}
  value=${3}

  dbus-send --print-reply=literal \
    --dest=org.mpris.MediaPlayer2.spotify \
    /org/mpris/MediaPlayer2 \
    org.freedesktop.DBus.Properties.Set \
      string:"org.mpris.MediaPlayer2.Player" \
      string:"${property}" \
      variant:${value_type}:"${value}"
}

dbus_get_spotify() {
  property=${1}
  dbus-send --print-reply=literal \
    --dest=org.mpris.MediaPlayer2.spotify \
    /org/mpris/MediaPlayer2 \
    org.freedesktop.DBus.Properties.Get \
    string:"org.mpris.MediaPlayer2.Player" \
    string:"${property}" | awk '{print $NF}'
}

raw_dbus_get_spotify() {
  property=${1}
  dbus-send --print-reply=literal \
    --dest=org.mpris.MediaPlayer2.spotify \
    /org/mpris/MediaPlayer2 \
    org.freedesktop.DBus.Properties.Get \
    string:"org.mpris.MediaPlayer2.Player" \
    string:"${property}" 
}

open_spotify() {
  spotify
}

toggle_play_pause() {
  dbus_send_spotify PlayPause
}

previous_track() {
  dbus_send_spotify Previous
}

next_track() {
  dbus_send_spotify Next
}

toggle_repeat() {
  repeat_state=$(dbus_get_spotify "LoopStatus")
  case "${repeat_state}" in
    "None")
      repeat_state="Playlist"
      ;;
    "Playlist")
      repeat_state="Track"
      ;;
    "Track")
      repeat_state="None"
      ;;
  esac

  dbus_set_spotify LoopStatus string $repeat_state
}

toggle_shuffle() {
  shuffle_state=$(dbus_get_spotify "Shuffle")
  case "${shuffle_state}" in
    "true")
      shuffle_state="false"
      ;;
    "false")
      shuffle_state="true"
      ;;
  esac

  dbus_set_spotify Shuffle boolean $shuffle_state
}

show_menu() {
  local METADATA=$(raw_dbus_get_spotify "Metadata")
  local artist=$(     awk '/\<artist\>/   { getline; gsub("]", ""); print }' <<< $METADATA | xargs )
  local track_name=$( awk ' /\<title\>/   { gsub(")", ""); pos=index($0, "variant"); print substr($0, pos+length("variant")) }' <<< $METADATA | xargs )
  local album=$(      awk ' /\<album\>/   { gsub(")", ""); pos=index($0, "variant"); print substr($0, pos+length("variant")) }' <<< $METADATA | xargs )
  local id=$(         awk ' /\<trackid\>/ { gsub(")", ""); pos=index($0, "variant"); print substr($0, pos+length("variant")) }' <<< $METADATA | xargs )

  # Create label of Repeating Status
  local repeate_mode=$(dbus_get_spotify "LoopStatus")
  local repeating_label="Repeat: ${repeate_mode}"

  # Create label of Shuffling Status
  local shuffle_mode=$(dbus_get_spotify "Shuffle")
  local shuffling_label="Shuffling: ${shuffle_mode}"

  if [ "$id" = "" ]; then
    $(tmux display-menu -T "#[align=centre fg=green]Spotify" -x R -y P \
        "Open Spotify"     o "run -b 'source \"$CURRENT_DIR/dbus_spotify.sh\" && open_spotify'" \
        "" \
        "Close menu"       q "" \
    )
  elif [[ $id == *":episode:"* ]]; then
    $(tmux display-menu -T "#[align=centre fg=green]Spotify" -x R -y P \
        "" \
        "-#[nodim]Episode: $track_name" "" "" \
        "-#[nodim]Podcast: $album"      "" "" \
        "" \
        "Copy URL"         c "run -b 'printf \"%s\" $id | pbcopy'" \
        "Open Spotify"     o "run -b 'source \"$CURRENT_DIR/dbus_spotify.sh\" && open_spotify'" \
        "Play/Pause"       p "run -b 'source \"$CURRENT_DIR/dbus_spotify.sh\" && toggle_play_pause'" \
        "Previous"         b "run -b 'source \"$CURRENT_DIR/dbus_spotify.sh\" && previous_track'" \
        "Next"             n "run -b 'source \"$CURRENT_DIR/dbus_spotify.sh\" && next_track'" \
        "$repeating_label" r "run -b 'source \"$CURRENT_DIR/dbus_spotify.sh\" && toggle_repeat $is_repeat_on'" \
        "$shuffling_label" s "run -b 'source \"$CURRENT_DIR/dbus_spotify.sh\" && toggle_shuffle $is_shuffle_on'" \
        "" \
        "Close menu"       q "" \
    )
  else
    $(tmux display-menu -T "#[align=centre fg=green]Spotify" -x R -y P \
        "" \
        "-#[nodim]Track: $track_name" "" "run -b 'printf \"%s\" $quoted_track_name | pbcopy'" \
        "-#[nodim]Artist: $artist"    "" "" \
        "-#[nodim]Album: $album"      "" "" \
        "" \
        "Open Spotify"     o "run -b 'source \"$CURRENT_DIR/dbus_spotify.sh\" && open_spotify'" \
        "Play/Pause"       p "run -b 'source \"$CURRENT_DIR/dbus_spotify.sh\" && toggle_play_pause'" \
        "Previous"         b "run -b 'source \"$CURRENT_DIR/dbus_spotify.sh\" && previous_track'" \
        "Next"             n "run -b 'source \"$CURRENT_DIR/dbus_spotify.sh\" && next_track'" \
        "$repeating_label" r "run -b 'source \"$CURRENT_DIR/dbus_spotify.sh\" && toggle_repeat $is_repeat_on'" \
        "$shuffling_label" s "run -b 'source \"$CURRENT_DIR/dbus_spotify.sh\" && toggle_shuffle $is_shuffle_on'" \
        "" \
        "Close menu"       q "" \
    )
  fi
}

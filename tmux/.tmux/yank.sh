#!/bin/bash

set -eu

maxlen=74994

buf=$(cat "$@")
buflen=$( printf %s "$buf" | wc -c )

if [ "$buflen" -gt "$maxlen" ]; then
   printf "input is %d bytes too long" "$(( buflen - maxlen ))" >&2
fi

# Build OSC 52 ANSI escape sequence
esc="\033]52;c;$( printf %s "$buf" | head -c $maxlen | base64 | tr -d '\r\n' )\a"

pane_active_tty=$(tmux list-panes -F "#{pane_active} #{pane_tty}" | awk '$1=="1" { print $2 }')
target_tty="${SSH_TTY:-$pane_active_tty}"
printf "$esc" > "$target_tty"

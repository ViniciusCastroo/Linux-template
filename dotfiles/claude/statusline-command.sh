#!/usr/bin/env bash

input=$(cat)
user=$(whoami)
host=$(hostname -s)
dir=$(printf '%s' "$input" | jq -r '.workspace.current_dir // empty')
[ -z "$dir" ] && dir=$(pwd)
dir="${dir/#$HOME/~}"
session_pct=$(printf '%s' "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')

printf '\033[01;32m%s@%s\033[00m:\033[01;34m%s\033[00m' "$user" "$host" "$dir"
if [ -n "$session_pct" ]; then
  printf ' \033[02;37m[session %s%%]\033[00m' "$(printf '%.0f' "$session_pct")"
fi

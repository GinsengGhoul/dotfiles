#!/bin/sh
fallback="/usr/share/backgrounds/sydney-moore-sogJgXYu4Ug-unsplash.jpg"

monitors="$(swaymsg -t get_outputs | jq -r '[ .[] | select(.active==true) | .name ] | join(" ")')"

if [ ! -d ~/.cache/swaylock ]; then
  mkdir -p ~/.cache/swaylock
fi

keyword="${1}"
case "${keyword}" in
set)
  for monitor in ${monitors}; do
    if [ ! -f ~/.cache/swaylock/lock-${monitor}.png ]; then
      grim -o ${monitor} - >~/.cache/swaylock/lock-${monitor}.png
    fi
  done
  brightnessctl s 500
  ;;
lock)
  shift
  for monitor in ${monitors}; do
    if [ ! -f ~/.cache/swaylock/lock-${monitor}.png ]; then
      imgs="${imgs} --image ${monitor}:${fallback}"
    else
      imgs="${imgs} --image ${monitor}:~/.cache/swaylock/lock-${monitor}.png"
    fi
    echo $imgs
  done

  if [ $(pgrep -f swaylock | wc -l) -gt 1 ]; then
    killall -q swaylock
  fi
  swaylock -C ~/.config/sway/swaylock.conf ${imgs} ${@}

  sleep 1
  ~/.config/sway/scripts/brightnessctl.sh restore
  ~/.config/sway/scripts/idle.sh on
  rm ~/.cache/swaylock/lock-*.png
  ;;
*)
  if [ $(pgrep -f swaylock | wc -l) -gt 1 ]; then
    killall -q swaylock
  fi
  swaylock -C ~/.config/sway/swaylock.conf ${@}
  ;;
esac

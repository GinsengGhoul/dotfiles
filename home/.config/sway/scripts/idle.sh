#!/bin/sh
# THERE CAN ONLY BE ONE KING
oPIDS="$(pgrep -f "${0}" | grep -v "^$$$")"
if [ ! -z "$oPIDS" ]; then
  echo "Killing existing instances of ${0}..."
  killall idle.sh
  echo "$oPIDS" | xargs kill -9 >/dev/null 2>&1
fi

STATEFILE="/tmp/swayidle/state"
LOGFILE="/tmp/swayidle/lastrun"
if [ ! -d /tmp/swayidle ]; then
  mkdir /tmp/swayidle
  echo "0" >"${STATEFILE}"
  touch "${LOGFILE}"
fi

checkRunning() {
  pgrep -x "$1" >/dev/null 2>&1
}

checkPipewire() {
  ss -lx | grep -q "pipewire-0"
}
checkPulseaudio() {
  ss -lx | grep -q "/pulse/native"
}

checkAudio() {
  checkPipewire || checkPulseaudio
}

current=$(cat "${STATEFILE}" 2>/dev/null)
action=$1

if [ "$action" = "toggle" ]; then
  if [ "$current" = "1" ]; then
    action="off"
  else
    action="on"
  fi
fi

case $action in
on)
  while :; do
    if [ $(pgrep -x "swayidle" | wc -l) -gt 1 ]; then
      killall -q swayidle
    fi
    if [ $(pgrep -xf "sway-audio-idle-inhibit" | wc -l) -gt 1 ]; then
      killall -q sway-audio-idle-inhibit
    fi

    if ! checkRunning swayidle; then
      /usr/bin/swayidle -C ~/.config/sway/swayidle.conf &
    fi

    while ! checkAudio; do
      sleep 5
    done

    if ! checkRunning '-f sway-audio-idle-inhibit'; then
      sway-audio-idle-inhibit &
    fi

    echo "1" >"${STATEFILE}"
    echo "$(date '+%Y-%m-%d %H:%M:%S')" | tee -a "${LOGFILE}"
    sleep 30
  done
  ;;

off)
  echo "Stopping idle services..."

  # Clean up processes cleanly
  killall -q swayidle
  killall -q sway-audio-idle-inhibit
  sleep 5
  echo "0" >"${STATEFILE}"
  ;;

*)
  echo "Usage: $0 {on|off|toggle}"
  exit 1
  ;;
esac

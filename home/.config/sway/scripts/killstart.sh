#!/bin/sh
# killstart.sh — restart

if [ -z "$1" ]; then
  echo "Usage: ${0} <command> [arguments]" >&2
  exit 2
fi

cmd="$1"
shift

proc_name="${cmd##*/}"
proc_name=$(echo "$proc_name" | cut -c 1-15)

# ( -_•)︻デ═一 you've got 5 seconds to die
i=0
while pgrep -x "$proc_name" >/dev/null 2>&1 && [ $i -lt 5 ]; do
  killall -q "$proc_name" 2>/dev/null
  sleep 1
  i=$((i + 1))
done

# double tap
if pgrep -x "$proc_name" >/dev/null 2>&1; then
  killall -9 -q "$proc_name" 2>/dev/null
  sleep 1
fi

sleep 1

"$cmd" "$@" &

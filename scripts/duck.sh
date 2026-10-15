#!/bin/bash
[ "$(uname)" = Darwin ] || exit 0  # macOS only
# usage: duck.sh start <level>      lower the system volume to <level> x current (exit 1 if it can't)
#        duck.sh restore-after <pid> put the volume back once <pid> (the speech) ends
state="${TMPDIR:-/tmp}/spoken-replies-duck"   # holds: original-volume claiming-pid
vol()     { osascript -e 'output volume of (get volume settings)' 2>/dev/null; }
muted()   { [ "$(osascript -e 'output muted of (get volume settings)' 2>/dev/null)" = true ]; }
setvol()  { osascript -e "set volume output volume $1" >/dev/null 2>&1; }
case "$1" in
  start)
    muted && exit 1
    if [ -s "$state" ]; then read -r orig _ < "$state"; else orig=$(vol); fi
    [[ "$orig" =~ ^[0-9]+$ ]] || exit 1
    new=$(awk -v o="$orig" -v l="$2" 'BEGIN { printf "%d", o * l + 0.5 }')
    setvol "$new" || exit 1
    echo "$orig 0" > "$state" ;;
  restore-after)
    read -r orig _ < "$state" 2>/dev/null && [[ "$orig" =~ ^[0-9]+$ ]] || exit 0
    echo "$orig $2" > "$state"                                       # claim the duck for this speech
    while kill -0 "$2" 2>/dev/null; do sleep 0.3; done
    read -r orig owner < "$state" 2>/dev/null || exit 0
    [ "$owner" = "$2" ] || exit 0                                    # a newer reply owns it now
    setvol "$orig"; rm -f "$state" ;;
esac
exit 0

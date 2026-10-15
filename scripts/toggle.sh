#!/bin/bash
[ "$(uname)" = Darwin ] || exit 0  # macOS only
# usage: toggle.sh voice|ding [on|off]   (no argument flips it)
. "$(dirname "$0")/lib.sh"
case "$1" in
  voice) f=$VOICE_OFF_FLAG; on_when=missing ;;
  ding)  f=$DING_OFF_FLAG; on_when=missing ;;
  *) echo "usage: toggle.sh voice|ding [on|off]"; exit 1 ;;
esac
is_on()  { if [ $on_when = exists ]; then [ -f "$f" ]; else [ ! -f "$f" ]; fi; }
set_on() { if [ $on_when = exists ]; then touch "$f"; else rm -f "$f"; fi; }
set_off(){ if [ $on_when = exists ]; then rm -f "$f"; else touch "$f"; fi; }
mkdir -p "$(dirname "$f")"
case "$2" in
  on) set_on ;;
  off) set_off ;;
  *) if is_on; then set_off; else set_on; fi ;;
esac
if is_on; then echo "$1 is on"; else echo "$1 is off"; fi
[ "$1" = voice ] && ! is_on && pkill -x say
exit 0

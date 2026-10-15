#!/bin/bash
# usage: ding.sh done|notify [delay-seconds]
. "$(dirname "$0")/lib.sh"
[ -f "$DING_OFF_FLAG" ] && exit 0
case "$1" in notify) s=$NOTIFY_SOUND ;; *) s=$DING_SOUND ;; esac
[ -n "$2" ] && sleep "$2"
afplay "/System/Library/Sounds/$s.aiff"

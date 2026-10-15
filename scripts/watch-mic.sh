#!/bin/bash
# usage: watch-mic.sh <pid>
# Kills <pid> (the speech) as soon as the microphone opens; exits when <pid> ends.
dir="$(dirname "$0")"
while kill -0 "$1" 2>/dev/null; do
  if [ "$("$dir/mic.sh")" = MIC_IN_USE ]; then kill "$1"; break; fi
  sleep 0.5
done

#!/bin/bash
[ "$(uname)" = Darwin ] || exit 0  # macOS only
# usage: media-resume.sh <pid>   Waits for the speech (<pid>) to end, then resumes paused music.
while kill -0 "$1" 2>/dev/null; do sleep 0.3; done
"$(dirname "$0")/media.sh" resume

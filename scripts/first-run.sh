#!/bin/bash
[ "$(uname)" = Darwin ] || exit 0  # macOS only
# SessionStart: one time only, if the optional media-control tool is missing, ask Claude to mention it.
flag="$HOME/.claude/voice-hint-shown"
[ -f "$flag" ] && exit 0
command -v media-control >/dev/null && exit 0
command -v brew >/dev/null || exit 0   # the hint is a brew command, so only show it to people who have brew
mkdir -p "$(dirname "$flag")"; touch "$flag"
echo "Spoken-replies plugin note, to mention once in your first reply and then never again: for the best experience it can pause the user's podcast or video while you talk, but that needs a small free tool. If they want it, they can run: brew install media-control. Mention this in one short sentence and put the command after the Below: marker."

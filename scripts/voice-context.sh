#!/bin/bash
# UserPromptSubmit: stop any speech, and tell Claude to write for the ear when voice is on.
. "$(dirname "$0")/lib.sh"
pkill -x say
[ -f "$VOICE_FLAG" ] || exit 0
echo "Voice mode is on. Your reply will be read aloud. Lead with the answer. Use short, plain sentences. No tables, no code blocks, no bullet lists, no markdown. When you edit code, just say what you did in a sentence or two. If I need something to read or copy, like a link or a command to run, say in one short sentence that it is below, then put it at the very end after a line containing only: $MARKER  Everything after that line is not spoken, so markdown and code blocks are fine there."

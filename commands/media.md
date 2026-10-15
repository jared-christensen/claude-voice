---
description: Turn music pausing on or off (pauses Apple Music and Spotify while Claude speaks)
argument-hint: on | off
allowed-tools: Bash(${CLAUDE_PLUGIN_ROOT}/scripts/toggle.sh:*)
---
!`${CLAUDE_PLUGIN_ROOT}/scripts/toggle.sh media $ARGUMENTS`

Reply with only the status line above, nothing else.

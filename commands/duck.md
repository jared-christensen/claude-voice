---
description: Turn volume ducking on or off (lowers other audio while Claude speaks)
argument-hint: on | off
allowed-tools: Bash(${CLAUDE_PLUGIN_ROOT}/scripts/toggle.sh:*)
---
!`${CLAUDE_PLUGIN_ROOT}/scripts/toggle.sh duck $ARGUMENTS`

Reply with only the status line above, nothing else.

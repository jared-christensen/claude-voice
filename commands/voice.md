---
description: Turn voice on or off (no argument flips it)
argument-hint: on | off
allowed-tools: Bash(${CLAUDE_PLUGIN_ROOT}/scripts/toggle.sh:*)
---
!`${CLAUDE_PLUGIN_ROOT}/scripts/toggle.sh voice $ARGUMENTS`

Reply with only the status line above, nothing else.

---
description: Turn mic awareness on or off (off = speak even while your mic is open, for demos)
argument-hint: on | off
allowed-tools: Bash(${CLAUDE_PLUGIN_ROOT}/scripts/toggle.sh:*)
---
!`${CLAUDE_PLUGIN_ROOT}/scripts/toggle.sh mic $ARGUMENTS`

Reply with only the status line above, nothing else.

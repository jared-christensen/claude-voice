#!/bin/bash
[ "$(uname)" = Darwin ] || exit 0  # macOS only
# Prints MIC_IN_USE or MIC_NOT_IN_USE. Compiles the Swift helper on first use (needs Xcode command line tools).
# usage: mic.sh [--build]
src="$(dirname "$0")/mic-in-use.swift"
cache="${CLAUDE_PLUGIN_DATA:-$HOME/.claude/voice}"
bin="$cache/mic-in-use"
if [ ! -x "$bin" ] || [ "$src" -nt "$bin" ]; then
  mkdir -p "$cache"
  swiftc -O "$src" -o "$bin" >/dev/null 2>&1 || { [ "$1" = --build ] || echo MIC_NOT_IN_USE; exit 0; }
fi
[ "$1" = --build ] && exit 0
"$bin" 2>/dev/null || echo MIC_NOT_IN_USE

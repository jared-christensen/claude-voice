# Shared defaults. Override any of these in ~/.claude/voice.conf
[ "$(uname)" = Darwin ] || exit 0  # macOS only
VOICE="Ava (Premium)|Ava (Enhanced)|Zoe (Premium)|Zoe (Enhanced)|Samantha"  # first installed one wins; none = system default
RATE=200            # words per minute
VOLUME=0.8          # speech volume, 0.0 - 1.0 (independent of system volume)
PAUSE_MS=500        # pause between paragraphs
DING_SOUND=Pop      # sound when a reply finishes (name from /System/Library/Sounds)
NOTIFY_SOUND=Bottle # sound when Claude needs permission or has a question
DING_DELAY=0.5      # seconds to wait before the ding that precedes speech
MARKER="Below:"     # text after a line with only this marker is never spoken
[ -f "$HOME/.claude/voice.conf" ] && . "$HOME/.claude/voice.conf"
VOICE_OFF_FLAG="$HOME/.claude/voice-off"
DING_OFF_FLAG="$HOME/.claude/ding-off"

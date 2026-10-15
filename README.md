# claude-voice (spoken-replies)

Hear Claude Code's replies read aloud on your Mac. macOS only, uses the built-in `say` command.

- Reads each reply when Claude finishes, in short spoken-friendly sentences.
- Plays a soft ding before the speech, or instead of it when voice is off or your mic is in use.
- Stops talking the moment your microphone opens, and stays quiet during calls and dictation.
- Plays a different sound when Claude needs permission or asks a question.
- Anything Claude puts after a `Below:` line (links, commands) is shown but never spoken.
- Sending any new prompt cuts off speech.

## Install

```
/plugin marketplace add jared-christensen/claude-voice
/plugin install spoken-replies@jared-tools
```

Restart Claude Code afterward, since hooks load at startup. Needs `jq` (`brew install jq`) and the Xcode command line tools (`xcode-select --install`) so the small mic-detection helper can compile on first run. Without them, speech still works but mic detection is skipped.

## Use

| Command | What it does |
| --- | --- |
| `/spoken-replies:voice` | Turn voice on or off (no argument flips it) |
| `/spoken-replies:ding` | Mute or unmute all sounds |
| `/spoken-replies:shh` | Stop the current speech, voice stays on |

Voice is **off** until you turn it on. State lives in two flag files: `~/.claude/voice-on` and `~/.claude/ding-off`.

## Configure

Create `~/.claude/voice.conf` and set any of these (defaults shown):

```
VOICE=""            # e.g. "Ava (Premium)"; empty = system default voice
RATE=200            # words per minute
VOLUME=0.8          # speech volume, independent of system volume
PAUSE_MS=500        # pause between paragraphs
DING_SOUND=Pop      # any name from /System/Library/Sounds
NOTIFY_SOUND=Bottle
DING_DELAY=0.5      # seconds before the ding that precedes speech
MARKER="Below:"
```

List installed voices with `say -v '?'`. Better ones (Ava, Zoe) are a free download in System Settings > Accessibility > Spoken Content > System Voice > Manage Voices. Premium voices ignore pitch commands but honor volume and rate. They also take about a second to start, so raise `DING_DELAY` to line the ding up with the first word.

## How it works

Three hooks: `UserPromptSubmit` adds a short instruction when voice is on so Claude writes for the ear, `Stop` cleans the reply (code blocks, links, markdown) and speaks it, and `Notification` plays the attention sound. `scripts/mic-in-use.swift` asks CoreAudio whether any input device is running.

## License

MIT

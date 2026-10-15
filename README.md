# claude-voice (spoken-replies)

Hear Claude Code's replies read aloud on your Mac.

> **macOS only.** It relies on the built-in `say` and `afplay` commands and CoreAudio. On Windows or Linux the scripts do nothing and exit quietly, so installing it there is harmless but pointless.

- Reads each reply when Claude finishes, in short spoken-friendly sentences.
- Plays a soft ding before the speech, or instead of it when voice is off or your mic is in use.
- Stops talking the moment your microphone opens, and stays quiet during calls and dictation.
- Plays a different sound when Claude needs permission or asks a question.
- Anything Claude puts after a `Below:` line (links, commands) is shown but never spoken.
- Sending any new prompt cuts off speech.

## Talk instead of type: the full loop

This pairs well with a dictation app. I use [Superwhisper](https://superwhisper.com): I hold a key and talk, it types my words into the Claude Code prompt, and Claude's reply is read back to me in short, plain sentences. I never touch the keyboard. Any voice-to-text tool should work the same way, for example [Wispr Flow](https://wisprflow.ai) or macOS's built-in Dictation. Some of these can also press Return for you after typing, which makes the loop completely hands-free (check your app's settings).

Two details make the loop feel natural:

- **Opening your mic interrupts the speech.** The moment your dictation app starts listening, Claude stops talking, so you can cut in whenever you've heard enough. While your mic is open, new replies play a soft ding instead of speaking over you.
- **Replies are written for the ear.** When voice is on, a small hook tells Claude on every message that the answer will be read aloud, so it leads with the answer and uses short sentences with no tables, bullet lists or markdown. Links and commands it needs you to see go after a `Below:` line and are never spoken.

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

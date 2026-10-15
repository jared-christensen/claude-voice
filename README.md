# claude-voice (spoken-replies)

**Claude Code that talks back.** When Claude finishes a reply, your Mac reads it to you out loud.

> **macOS only.** It uses the built-in `say` and `afplay` commands and CoreAudio. On Windows or Linux the scripts do nothing and exit quietly, so installing it there is harmless but pointless.

## What is this?

A small Claude Code plugin that turns your terminal into a conversation you can listen to. Three things make it work well:

- **Claude writes for the ear.** While voice is on, a hook tells Claude on every message that its reply will be read aloud. So it leads with the answer and uses short, plain sentences, with no tables, bullet lists or markdown. Links and commands you need to see go after a `Below:` line, and they are shown but never spoken.
- **It gets out of your way.** Opening your microphone instantly stops the speech, so you can cut in whenever you've heard enough. While your mic is open, replies play a soft ding instead of talking over you. That means it stays quiet in meetings and while you dictate.
- **It tells you when it needs you.** A soft ding plays when a reply finishes with voice off, and a different one plays when Claude needs permission or asks a question.

Pair it with a dictation app and you can run Claude Code without touching the keyboard (see [the full loop](#talk-instead-of-type-the-full-loop)).

## Quick start

In Claude Code, run:

```
/plugin marketplace add jared-christensen/claude-voice
/plugin install spoken-replies@jared-tools
```

Then **restart Claude Code** (hooks load at startup). That's it. Voice is on by default and the next reply will be read to you.

You need `jq` (`brew install jq`) and the Xcode command line tools (`xcode-select --install`). The tools let a tiny mic-detection helper compile on first run. Without them, speech still works but mic detection is skipped.

For the voice I use and the speed I like, jump to [my settings](#my-settings-a-good-place-to-start).

## Use it

| Command | What it does |
| --- | --- |
| `/spoken-replies:voice` | Turn voice on or off (no argument flips it) |
| `/spoken-replies:ding` | Mute or unmute every sound |
| `/spoken-replies:shh` | Stop the current speech, voice stays on |

Sending any new prompt also cuts off speech. Voice and sound state live in two flag files, `~/.claude/voice-off` and `~/.claude/ding-off`. If one exists, that feature is off.

## My settings (a good place to start)

I use **Ava (Premium)** at **speed 285** (the default), with the speech volume turned down to 60% so I can keep my system volume up. To use the same, create `~/.claude/voice.conf`:

```
VOICE="Ava (Premium)"
RATE=285
VOLUME=0.6
DING_DELAY=1
```

Ava is a free download: System Settings > Accessibility > Spoken Content > System Voice > Manage Voices, then pick Ava (Premium). Premium voices take about a second to start, which is why `DING_DELAY=1` lines the ding up with her first word.

Voices I tried:

| Voice | Take |
| --- | --- |
| **Ava (Premium)** | My favorite. The most natural sounding, and still clear at fast speeds. |
| Zoe (Premium) | Close second. A little slower to start. |
| **Alex** | Built in to every Mac, starts fastest, and holds up best at very high speeds. Less natural, but a great fallback. |
| Evan (Enhanced), Samantha | Fine, a step below the others. |

About speed: the default is 285, which is brisk but clear, and about as fast as I find comfortable. Past roughly 300 words start to blur. If that's too fast, set `RATE=235` (or 200 for a relaxed pace) in `~/.claude/voice.conf`.

## Talk instead of type: the full loop

This pairs well with a dictation app. I use [Superwhisper](https://superwhisper.com): I hold a key and talk, it types my words into the Claude Code prompt, and Claude's reply is read back to me. I never touch the keyboard. Any voice-to-text tool should work the same way, for example [Wispr Flow](https://wisprflow.ai) or macOS's built-in Dictation. Some can also press Return for you after typing, which makes the loop completely hands-free (check your app's settings).

Opening your mic to dictate cuts off whatever is being read, so interrupting is just a matter of starting to talk.

## Configure

Everything is optional. Put overrides in `~/.claude/voice.conf` (defaults shown):

```
VOICE="Ava (Premium)|Ava (Enhanced)|Zoe (Premium)|Zoe (Enhanced)|Alex|Samantha"
RATE=285            # words per minute
VOLUME=0.8          # speech volume, independent of system volume
PAUSE_MS=500        # pause between paragraphs
DING_SOUND=Pop      # any name from /System/Library/Sounds
NOTIFY_SOUND=Bottle # plays when Claude needs permission or has a question
DING_DELAY=0.5      # seconds before the ding that precedes speech
MARKER="Below:"     # text after a line with only this is never spoken
```

`VOICE` takes one name or a list separated by `|`. The first installed voice is used, and if none are, your Mac's default voice speaks, so it always works out of the box. List what you have with `say -v '?'`.

## How it works

Three hooks do the work. `UserPromptSubmit` stops any speech and, when voice is on, adds the short "write for the ear" instruction. `Stop` cleans the reply (code blocks become "code omitted", links and markdown are stripped) and speaks it. `Notification` plays the attention sound. `scripts/mic-in-use.swift` asks CoreAudio whether any input device is running, and a small watcher stops the speech the moment one is.

## License

MIT

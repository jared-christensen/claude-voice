# claude-voice (spoken-replies)

**Claude Code that talks back.** When Claude finishes a reply, your Mac reads it to you out loud.

> **macOS only.** It uses the built-in `say` and `afplay` commands and CoreAudio. On Windows or Linux the scripts do nothing and exit quietly, so installing it there is harmless but pointless.

https://github.com/user-attachments/assets/9edcc3e8-ddf4-4101-9f19-7068b0d174d9

🔊 *The video starts muted. Click the speaker icon to turn the sound on.*

## What is this?

A small Claude Code plugin that turns your terminal into a conversation you can listen to. A few things make it work well:

- **Claude writes for the ear.** While voice is on, a hook tells Claude on every message that its reply will be read aloud. So it leads with the answer and uses short, plain sentences, with no tables, bullet lists or markdown. Links and commands you need to see go after a `Below:` line, and they are shown but never spoken.
- **It gets out of your way.** Opening your microphone instantly stops the speech, so you can cut in whenever you've heard enough. While your mic is open, replies play a soft ding instead of talking over you. That means it stays quiet in meetings and while you dictate.
- **Other audio fades back.** While Claude talks, your system volume dips so music, podcasts or videos drop into the background, then it comes back up when the speech ends. Works with any audio, including browsers. Turn it off with `/spoken-replies:duck`.
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

To see the voice and speed it uses by default, and the other voices I tried, see [my settings](#my-settings-these-are-the-defaults).

## Use it

| Command | What it does |
| --- | --- |
| `/spoken-replies:voice` | Turn voice on or off (no argument flips it) |
| `/spoken-replies:ding` | Mute or unmute every sound |
| `/spoken-replies:shh` | Stop the current speech, voice stays on |
| `/spoken-replies:duck` | Turn volume ducking on or off (lowers other audio while Claude speaks) |
| `/spoken-replies:mic` | Turn mic awareness on or off. Off means it speaks even while your mic is open, which is handy for screen recordings and demos |

Sending any new prompt also cuts off speech. Voice and sound state live in two flag files, `~/.claude/voice-off`, `~/.claude/ding-off`, `~/.claude/duck-off` and `~/.claude/mic-ignore`. If one exists, that feature is off (for mic-ignore, mic awareness is off).

## My settings (these are the defaults)

The defaults are the settings I use every day, so most people never need to touch anything: **Ava (Premium)** at **speed 285**, with the speech volume at 60% so I can keep my system volume up, and a one-second ding delay so the ding lands as she starts talking. If Ava isn't installed, it falls back down a list (Zoe, then Alex, then Samantha, then your Mac's default voice).

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

Everything is optional. To change anything, create `~/.claude/voice.conf` and set just the lines you want (defaults shown):

```
VOICE="Ava (Premium)|Ava (Enhanced)|Zoe (Premium)|Zoe (Enhanced)|Alex|Samantha"
RATE=285            # words per minute
VOLUME=0.6          # speech volume, independent of system volume
PAUSE_MS=500        # pause between paragraphs
DING_SOUND=Pop      # any name from /System/Library/Sounds
NOTIFY_SOUND=Bottle # plays when Claude needs permission or has a question
DUCK_LEVEL=0.6      # other audio drops to this fraction of your system volume while speaking
DING_DELAY=1        # seconds before the ding that precedes speech
MARKER="Below:"     # text after a line with only this is never spoken
```

`VOICE` takes one name or a list separated by `|`. The first installed voice is used, and if none are, your Mac's default voice speaks, so it always works out of the box. List what you have with `say -v '?'`.

## Volume ducking: how it works

While Claude speaks, your system volume drops to `DUCK_LEVEL` (default 60%) of whatever it was, and returns afterward. Because that would also quiet Ava, the speech is played louder to make up for it, so she sounds the same while everything else fades back. This needs headroom: it works best when `VOLUME` (the speech volume) is at or below `DUCK_LEVEL`, as it is by default (both 0.6). Set `DUCK_LEVEL` lower for a deeper fade, but below `VOLUME` the speech gets quieter too. The volume is only restored if nothing else changed it, and if your Mac is muted it's left alone.

## How it works

Three hooks do the work. `UserPromptSubmit` stops any speech and, when voice is on, adds the short "write for the ear" instruction. `Stop` cleans the reply (code blocks become "code omitted", links and markdown are stripped) and speaks it. `Notification` plays the attention sound. `scripts/mic-in-use.swift` asks CoreAudio whether any input device is running, and a small watcher stops the speech the moment one is.

## License

MIT

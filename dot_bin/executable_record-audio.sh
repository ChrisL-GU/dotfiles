#!/bin/bash

# Default to System Audio, but you can pass "mic" as an argument
MODE=${1:-system}
mkdir -p "$HOME/Documents/Recordings"
FILENAME="Record_$(date +'%Y-%m-%d_%H-%M').mp3"

if [ "$MODE" == "mic" ]; then
    # RECORD THE ROOM: Use the default source (your microphone)
    TARGET="@DEFAULT_SOURCE@"
    MSG="🎤 Recording MICROPHONE (The Room)"
else
    # RECORD THE SYSTEM: Use the Meeting Sink monitor
    TARGET="meeting_sink.monitor"
    MSG="💻 Recording SYSTEM (Meetings)"
fi

# Notification happens in toggle-audio-record.sh
# notify-send "🎙️ Audio Recorder" "$MSG"

/usr/bin/pw-record --target="$TARGET" --format=s16 --rate=48000 --channels=2 - | \
/usr/bin/ffmpeg -f s16le -ar 48000 -ac 2 -i - -c:a libmp3lame -q:a 2 "$HOME/Documents/Recordings/$FILENAME"


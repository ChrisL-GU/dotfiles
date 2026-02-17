#!/bin/bash

# We use a temp file to track the notification ID so we can replace/close it
NOTIFY_ID_FILE="/tmp/audio_record_notify_id"

# Check if recording is already running
PID=$(pgrep -f "record-audio.sh")

# Function to play sound even if system sounds are muted
play_sound() {
    # --volume=32768 is 50%, 65536 is 100%
    paplay --volume=65536 "/usr/share/sounds/freedesktop/stereo/$1.oga" &
}

if [ -z "$PID" ]; then
    # --- STARTING ---
    # Play a "start" sound (shutter or bell)
    play_sound "service-login"

    ~/.bin/record-audio.sh system &
    
    # Send a CRITICAL notification (stays on screen in Gnome)
    # The 'print-id' lets us grab the ID so we can close it later
    notify-send "🎙️ RECORDING ACTIVE" \
        "● LIVE NOW: System audio is being captured..." \
        --icon=media-record \
        --urgency=critical \
        --hint=string:x-canonical-private-synchronous:audio-recording \
        --print-id > "$NOTIFY_ID_FILE"
else
    # --- STOPPING ---
    # Play a "stop" sound (trash or message)
    play_sound "service-logout"

    pkill -f "record-audio.sh"
    pkill -f "pw-record"
    pkill -f "ffmpeg"

    # Close the "Active" notification using the stored ID
    if [ -f "$NOTIFY_ID_FILE" ]; then
        ID=$(cat "$NOTIFY_ID_FILE")
        # Standard gdbus command to close a notification by ID
        gdbus call --session --dest org.freedesktop.Notifications \
            --object-path /org/freedesktop/Notifications \
            --method org.freedesktop.Notifications.CloseNotification "$ID"
        rm "$NOTIFY_ID_FILE"
    fi

    # Send a brief "Saved" notification (normal urgency, disappears)
    notify-send "🛑 RECORDING SAVED" "File exported to Documents/Recordings" \
        --icon=media-playback-stop \
        --urgency=normal
fi

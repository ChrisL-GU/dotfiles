#!/bin/bash

NOTIFY_ID_FILE="/tmp/mic_record_notify_id"
PID=$(pgrep -f "record-audio.sh mic")

play_sound() {
    paplay --volume=65536 "/usr/share/sounds/freedesktop/stereo/$1.oga" &
}

if [ -z "$PID" ]; then
    # --- STARTING ---
    play_sound "service-login"
    
    # We pass 'mic' as the argument here
    ~/.bin/record-audio.sh mic &
    
    notify-send "🎤 MIC RECORDING" \
        "⏺ LIVE NOW: Capturing the room..." \
        --icon=audio-input-microphone \
        --urgency=critical \
        --hint=string:x-canonical-private-synchronous:mic-recording \
        --print-id > "$NOTIFY_ID_FILE"
else
    # --- STOPPING ---
    play_sound "service-logout"

    pkill -f "record-audio.sh mic"
    pkill -f "pw-record"
    pkill -f "ffmpeg"

    if [ -f "$NOTIFY_ID_FILE" ]; then
        ID=$(cat "$NOTIFY_ID_FILE")
        gdbus call --session --dest org.freedesktop.Notifications \
            --object-path /org/freedesktop/Notifications \
            --method org.freedesktop.Notifications.CloseNotification "$ID" > /dev/null
        rm "$NOTIFY_ID_FILE"
    fi

    notify-send "🛑 MIC SAVED" "Room recording saved to Documents/Recordings" \
        --icon=media-playback-stop --urgency=normal
fi

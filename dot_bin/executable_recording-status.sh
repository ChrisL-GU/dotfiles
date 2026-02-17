#!/bin/bash

# Quick check: Is anyone recording? 
# Using -f to match the script name exactly
if ! pgrep -f "record-audio.sh" > /dev/null; then
    # Output nothing and EXIT immediately.
    # Executor will just show an empty space in your bar.
    echo ""
    exit 0
fi

# --- Everything below ONLY runs if you are recording ---

# Check which one is active
SYS_PID=$(pgrep -f "record-audio.sh system")
MIC_PID=$(pgrep -f "record-audio.sh mic")
ACTIVE_PID=${SYS_PID:-$MIC_PID}

START=$(stat -c %Y /proc/$ACTIVE_PID)
TIME=$(date -d@$(( $(date +%s) - START )) -u +%M:%S)

if [ -n "$SYS_PID" ]; then
    echo "🔴 REC $TIME"
else
    echo "🎤 MIC $TIME"
fi

#!/bin/bash

echo "Watching for winedbg... (Press [CTRL+C] to stop)"

while true
do
    # Check if winedbg is running
    if pgrep -f "winedbg" > /dev/null; then
        echo "Detected winedbg! Closing it now..."

        # Kill only the debugger processes
        pkill -f "winedbg"

        # Optional: Give a small notification
        echo "Debugger dismissed. Multisim should continue."
    fi

    # Sleep for 1 second to keep CPU usage at ~0%
    sleep 1
done

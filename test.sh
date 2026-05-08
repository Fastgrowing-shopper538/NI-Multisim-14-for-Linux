if [ -f /etc/debian_version ]; then
    echo "Debian-based distro detected. Fixing desktop launcher..."

    DESKTOP_FILE="$HOME/.local/share/applications/wine/Programs/National Instruments/Circuit Design Suite 14.0/Multisim 14.0.desktop"

    if [ -f "$DESKTOP_FILE" ]; then
        sed -i \
        's|^Exec=|Exec=env WINEPREFIX='"$HOME"'/.multisim32 PATH=/opt/wine-stable/bin:$PATH |' \
        "$DESKTOP_FILE"

        echo "Desktop launcher fixed."
    else
        echo "Desktop file not found."
    fi
fi

current=$(powerprofilesctl get)
case "$current" in
    "power-saver")
        powerprofilesctl set balanced
        notify-send "Power Profile" "Switched to Balanced"
        ;;
    "balanced")
        powerprofilesctl set performance  
        notify-send "Power Profile" "Switched to Performance"
        ;;
    "performance")
        powerprofilesctl set power-saver
        notify-send "Power Profile" "Switched to Power Saver"
        ;;
esac

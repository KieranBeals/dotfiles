#!/usr/bin/env bash

current=$(powerprofilesctl get 2>/dev/null || echo "unknown")

case "$current" in
    "performance") echo "󱓞" ;;
    "balanced") echo " " ;;
    "power-saver") echo "󱐋" ;;
    *) echo "" ;;
esac

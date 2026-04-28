#!/usr/bin/env bash

# Weather script for Waybar
# Uses wttr.in API for weather information

fetch_weather() {
    local url="https://wttr.in/?format=j1"
    local curl_args=(
        --silent
        --max-time 10
        "$url"
    )

    sudo -n --user=weather-novpn /run/current-system/sw/bin/curl "${curl_args[@]}" 2>/dev/null ||
        curl "${curl_args[@]}" 2>/dev/null
}

get_weather() {
    # Fetch weather data from wttr.in
    weather_data=$(fetch_weather)

    if [ -z "$weather_data" ]; then
        jq -nc --arg text "" --arg tooltip "Weather data unavailable" \
            '{text: $text, tooltip: $tooltip}'
        return
    fi

    # Parse JSON data
    temp=$(jq -r '.current_condition[0].temp_C' <<<"$weather_data")
    feels_like=$(jq -r '.current_condition[0].FeelsLikeC' <<<"$weather_data")
    condition=$(jq -r '.current_condition[0].weatherDesc[0].value' <<<"$weather_data")
    humidity=$(jq -r '.current_condition[0].humidity' <<<"$weather_data")
    wind_speed=$(jq -r '.current_condition[0].windspeedKmph' <<<"$weather_data")

    # Choose icon based on weather condition
    case "$condition" in
        *"Sunny"*|*"Clear"*)
            icon=" "
            ;;
        *"Partly cloudy"*)
            icon=" "
            ;;
        *"Cloudy"*|*"Overcast"*)
            icon=" "
            ;;
        *"Rain"*|*"Drizzle"*)
            icon=" "
            ;;
        *"Snow"*|*"Light snow"*)
            icon=" "
            ;;
        *"Thunder"*|*"storm"*)
            icon=" "
            ;;
        *"Mist"*|*"Fog"*)
            icon=" "
            ;;
        *)
            icon=""
            ;;
    esac

    # Create tooltip with detailed information
    tooltip=$(printf '<b>Weather</b>\nCondition: %s\nTemperature: %s°C (feels like %s°C)\nHumidity: %s%%\nWind: %s km/h' \
        "$condition" "$temp" "$feels_like" "$humidity" "$wind_speed")

    # Output JSON for Waybar
    jq -nc --arg text "${icon}${temp}°C" --arg tooltip "$tooltip" \
        '{text: $text, tooltip: $tooltip}'
}

weather_output=$(get_weather)
echo "$weather_output"

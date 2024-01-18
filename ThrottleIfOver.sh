#!/bin/bash

if [ "$EUID" -ne 0 ]; then
    echo "Root privileges required."
    exit 1
fi

# Don't let CPU go over this temperature
if [ "$#" -gt 0 ]; then
    max_temp=$1
else
    # use safe default
    max_temp=65
fi

# Start throttling when temperature is max_temp - padding
# to account for thermal mass, spikes, slow governors, etc.
padding=10

if [[ $padding -eq null ]]; then
    # use safe default
    padding=10
fi

threshold=$((max_temp - padding))

throttled=false


function unthrottle() {
    sudo cpufreq-set -c 0 --max 1516MHz
    sudo cpufreq-set -c 1 --max 1516MHz
    sudo cpufreq-set -c 2 --max 1516MHz
    sudo cpufreq-set -c 3 --max 1516MHz
    sudo cpufreq-set -c 4 --max 2016MHz
    sudo cpufreq-set -c 5 --max 2016MHz
}

function throttle() {
    sudo cpufreq-set -c 0 --max 408MHz
    sudo cpufreq-set -c 1 --max 408MHz
    sudo cpufreq-set -c 2 --max 408MHz
    sudo cpufreq-set -c 3 --max 408MHz
    sudo cpufreq-set -c 4 --max 408MHz
    sudo cpufreq-set -c 5 --max 408MHz
}

## start unthrottled
unthrottle

# Main Loop
#
while true; do
    current_temp=$(cat /sys/class/thermal/thermal_zone0/temp)
    current_temp=$((current_temp / 1000))

    if [[ $current_temp -gt $max_temp ]]; then
        echo $(date) "$current_temp > $max_temp: Throttling"
        throttle
        throttled=true
    elif $throttled ; then
        if [[ $current_temp -lt $threshold ]]; then
            echo $(date) "$current_temp < $threshold: Unthrottling"
            unthrottle
            unthrottled=true
        fi
    fi
    # echo $(date) "$current_temp"
    sleep 1
done

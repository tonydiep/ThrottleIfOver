#!/bin/bash

max_temp=$1

# to account for thermal mass
padding=10

if [[ $max_temp -eq null ]] ; then
	echo "Specify temperature in celcius. Example Usage: ThrotleIfOver 60"
	exit 1
fi

low_temp=$(( max_temp - padding ))
throttled=1

while true; do
    current_temp=`cat /sys/class/thermal/thermal_zone0/temp`
    current_temp=$((current_temp / 1000))

    if [[ $current_temp -gt $max_temp ]]; then
        echo `date` "$current_temp > $max_temp: Throttling"

        sudo cpufreq-set -c 0 --max 408MHz
        sudo cpufreq-set -c 1 --max 408MHz
        sudo cpufreq-set -c 2 --max 408MHz
        sudo cpufreq-set -c 3 --max 408MHz
        sudo cpufreq-set -c 4 --max 408MHz
        sudo cpufreq-set -c 5 --max 408MHz

        throttled=1

    elif [[ $throttled -eq 1 ]]; then

        if [[ $current_temp -lt $low_temp ]]; then
            echo `date` "$current_temp < $low_temp: Unthrottling"
            sudo cpufreq-set -c 0 --max 1516MHz
            sudo cpufreq-set -c 1 --max 1516MHz
            sudo cpufreq-set -c 2 --max 1516MHz
            sudo cpufreq-set -c 3 --max 1516MHz
            sudo cpufreq-set -c 4 --max 2016MHz
            sudo cpufreq-set -c 5 --max 2016MHz

	    throttled=0
        fi
    fi

    echo `date` "$current_temp"

    sleep 1
done
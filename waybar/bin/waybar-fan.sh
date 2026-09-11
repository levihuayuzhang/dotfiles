#!/run/current-system/sw/bin/bash

hwmon=$(dirname "$(grep -rl '^lenovo_wmi_other$' /sys/class/hwmon/*/name)")

if [ -z "$hwmon" ]; then
    echo "󰈐 N/A"
    exit 0
fi

max_rpm=0

for fan in fan1 fan2 fan4; do
    if [ -f "$hwmon/${fan}_input" ]; then
        rpm=$(cat "$hwmon/${fan}_input")

        if [ "$rpm" -gt "$max_rpm" ]; then
            max_rpm=$rpm
        fi
    fi
done

echo "󰈐 ${max_rpm} RPM"

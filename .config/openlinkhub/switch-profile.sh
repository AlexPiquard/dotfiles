#!/bin/bash

# corsair devices
DEVICES=(
	"02010017AF97A48860F5C23DF5001C04"
    "26B00316A9843EAFBF3FED5BC21B00F5"
)

URL="http://127.0.0.1:27003/api/userProfile/change"
STATE_FILE="/tmp/rgb_multi_index"

# common profiles of devices
PROFILES=("rainbow" "gradient" "off")

# get current profile index
[ -f "$STATE_FILE" ] && INDEX=$(cat "$STATE_FILE") || INDEX=0
PROFILE_NAME=${PROFILES[$INDEX]}

# apply profile on each device
for DEV_ID in "${DEVICES[@]}"; do
    curl -X POST "$URL" \
         -H "Content-Type: application/json" \
         -d "{\"deviceId\":\"$DEV_ID\", \"userProfileName\":\"$PROFILE_NAME\"}" \
         --silent > /dev/null &
done

# increment index for next call
NEXT_INDEX=$(( (INDEX + 1) % ${#PROFILES[@]} ))
echo "$NEXT_INDEX" > "$STATE_FILE"

echo "Applied profile $PROFILE_NAME to all devices"

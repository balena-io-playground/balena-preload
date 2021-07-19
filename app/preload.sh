#!/bin/bash

set -eu

echo "balena CLI:"
balena version
docker version

# keep the filenames somewhat unique
target_img="/images/${PRELOAD_APP_NAME//[^[:alnum:]_-]/}"
target_img="${target_img}-${PRELOAD_DEVICE_TYPE//[^[:alnum:]_-]/}"
target_img="${target_img}-${PRELOAD_OS_VERSION//[^[:alnum:]_-]/}"
target_img="${target_img}-${PRELOAD_APP_RELEASE//[^[:alnum:]_-]/}"
target_img="${target_img}.img"

# balena login with api key
echo "Logging in..."
balena login --token "${CLI_API_KEY}"

# verify the app exists and has at least one release
echo "Verifying '${PRELOAD_APP_NAME}' has at least one release..."
balena app "${PRELOAD_APP_NAME}" | grep -q COMMIT

# download the specified os version
echo "Downloading OS version '${PRELOAD_OS_VERSION}'..."
balena os download "${PRELOAD_DEVICE_TYPE}" \
    --version "${PRELOAD_OS_VERSION}" \
    --output "${target_img}" \
    --debug

# configure the downloaded os
echo "Configuring OS image with '${PRELOAD_NETWORK}'..."
balena os configure "${target_img}" \
    --app "${PRELOAD_APP_NAME}" \
    --config-network "${PRELOAD_NETWORK}" \
    --config-wifi-ssid "${PRELOAD_WIFI_SSID:-}" \
    --config-wifi-key "${PRELOAD_WIFI_KEY:-}" \
    --device-type "${PRELOAD_DEVICE_TYPE}" \
    --debug

# preload the app containers and optionally pin the release
echo "Preloading image with release '${PRELOAD_APP_RELEASE}'..."
case ${PRELOAD_APP_PINNED} in
y)
    balena preload "${target_img}" \
        --app "${PRELOAD_APP_NAME}" \
        --commit "${PRELOAD_APP_RELEASE}" \
        --pin-device-to-release \
        --debug
    ;;
n)
    balena preload "${target_img}" \
        --app "${PRELOAD_APP_NAME}" \
        --commit "${PRELOAD_APP_RELEASE}" \
        --debug
    ;;
*)
    echo "PRELOAD_APP_PINNED must be 'y' or 'n'"
    exit 1
    ;;
esac

echo "Preload complete!"
echo "Images can be downloaded via file server on port 80."

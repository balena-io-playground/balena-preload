# balena-preload

Generate balenaOS images preloaded with the specified app release and
make those images available for download via http.

This avoids each device having to download the release from the cloud
when connected, and optionally could run without internet access.

## Getting Started

You can one-click-deploy this project to balena using the button below:

[![balena deploy button](https://www.balena.io/deploy.svg)](https://dashboard.balena-cloud.com/deploy?repoUrl=https://github.com/balena-io-playground/balena-preload)

## Manual Deployment

Alternatively, deployment can be carried out by manually creating a [balenaCloud account](https://dashboard.balena-cloud.com) and application,
flashing a device, downloading the project and pushing it via the [balena CLI](https://github.com/balena-io/balena-cli).

## Usage

By setting the various environment variables outlined below you can
generate any number of preloaded balenaOS images for download.

Set the required vars in the Dashboard and watch the `app` logs to
see that your image has been created, it could take a few minutes.

Once the image is generated, the app will sleep indefinitely until new
environment variables are provided.

The images can be downloaded via `http://device-ip:80/` or by enabling
the Public Device URL in the Dashboard.

## Environment Variables

| Name                  | Default    | Description                                                         |
| --------------------- | ---------- | ------------------------------------------------------------------- |
| `CLI_API_KEY`         |            | (required) used to authenticate to a balenaCloud user account       |
| `PRELOAD_APP_NAME`    |            | (required) name of the application to preload                       |
| `PRELOAD_DEVICE_TYPE` |            | (required) device type slug to override the application device type |
| `PRELOAD_APP_RELEASE` | `current`  | commit hash for a specific application release to preload           |
| `PRELOAD_APP_PINNED`  | `y`        | pin the preloaded device to the release on provision (`y`/`n`)      |
| `PRELOAD_OS_VERSION`  | `latest`   | balenaOS version, for example `2.32.0` or `2.44.0+rev1`             |
| `PRELOAD_NETWORK`     | `ethernet` | device network type (`ethernet`/`wifi`)                             |
| `PRELOAD_WIFI_SSID`   |            | WiFi SSID (network name)                                            |
| `PRELOAD_WIFI_KEY`    |            | WiFi key (password)                                                 |

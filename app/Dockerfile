FROM node:12.22.3-alpine3.14 AS build

WORKDIR /usr/src/app

# install dependencies to build balena-cli via npm
# hadolint ignore=DL3018
RUN apk add --no-cache build-base ca-certificates curl git python3 wget linux-headers

# balena-cli version can be set at build time
ARG BALENA_CLI_VERSION=12.44.24

# install balena-cli via npm
RUN npm install balena-cli@${BALENA_CLI_VERSION} --production

FROM node:12.22.3-alpine3.14 AS balena-cli

WORKDIR /usr/src/app

# copy app from build stage
COPY --from=build /usr/src/app/ ./

# update path to include app bin directory
ENV PATH $PATH:/usr/src/app/node_modules/.bin/

# https://github.com/balena-io/balena-cli/blob/master/INSTALL-LINUX.md#additional-dependencies
# hadolint ignore=DL3018
RUN apk add --no-cache avahi bash ca-certificates docker jq openssh

# fail if binaries are missing or won't run
RUN balena --version && dockerd --version && docker --version

# install entrypoint script
COPY entrypoint.sh ./

# extract the list of balena-cli commands and update the entrypoint script
RUN CLI_CMDS=$(jq -r '.commands | keys | map(.[0:index(":")]) | unique | join("\\ ")' < node_modules/balena-cli/oclif.manifest.json); \
    sed -e "s/CLI_CMDS=.*/CLI_CMDS=\"help\\ ${CLI_CMDS}\"/" -i entrypoint.sh && \
    chmod +x entrypoint.sh

ENTRYPOINT [ "/usr/src/app/entrypoint.sh" ]

# default balena-cli command
CMD [ "help" ]

ENV SSH_AUTH_SOCK /ssh-agent
ENV DOCKER_HOST unix:///var/run/docker.sock
ENV DOCKER_PIDFILE /var/run/docker.pid
ENV DOCKER_LOG_DRIVER json-file
ENV DOCKER_DATA_ROOT /var/lib/docker
ENV DOCKER_EXEC_ROOT /var/run/docker
ENV DOCKER_LOGFILE /var/run/docker.log

# docker data root must be a volume or tmpfs
VOLUME /var/lib/docker

FROM balena-cli

WORKDIR /usr/src/app

# install preload script
COPY preload.sh .

RUN chmod +x ./preload.sh

CMD [ "./preload.sh" ]

ENV DOCKERD 1
ENV PRELOAD_DEVICE_TYPE raspberrypi3
ENV PRELOAD_OS_VERSION latest
ENV PRELOAD_APP_RELEASE current
ENV PRELOAD_NETWORK ethernet
ENV PRELOAD_APP_PINNED y

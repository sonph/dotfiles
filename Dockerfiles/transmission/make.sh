#!/bin/bash

# Helper script for building, starting and stopping container.

source common_utils.sh

IMAGE_NAME="sonph/transmission"
CONTAINER_NAME='transmission_ctn'

function build() {
  if [[ $# -lt 1 ]]; then
    info "Usage: ./make.sh build <password>"
    echo "Password is used to login to the transmission web interface."
    echo "Default username is 'transmission'"
    return 1
  fi
  # This password is set at image build time and passed from
  # make.sh > Dockerfile (LABEL + RUN) > transmission.sh configure > settings.json
  local password="$1"
  info "Building image: $IMAGE_NAME"
  docker build \
      -t "$IMAGE_NAME" \
      --build-arg password="$password" \
      ./ && \
      info "Listing images" && \
      docker image ls
}

function start() {
  if [[ "$(docker container ls -a | grep -c "$CONTAINER_NAME")" -lt 1 ]]; then
    create
    readonly local status=$? && [[ $status -ne 0 ]] && return $status
  fi
  info "Starting: $CONTAINER_NAME"
  docker start "$CONTAINER_NAME"
  if command -v > /dev/null docker-machine 2>&1; then
    info "Url: http://$(docker-machine ip):9091 (docker-machine)"
  else
    info "Url: http://localhost:9091"
  fi
  info "Download path: $PWD/downloads"
  info "Config path: $PWD/config"
}

function create() {
  mkdir config downloads > /dev/null 2>&1
  info "Creating container: $CONTAINER_NAME"
  docker create \
      --name=$CONTAINER_NAME \
      -v "$PWD/config":/config \
      -v "$PWD/downloads":/downloads \
      -p 9091:9091 \
      -p 51413:51413 \
      -p 51413:51413/udp \
      "$IMAGE_NAME"
}

function stop() {
  docker container stop "$CONTAINER_NAME"
}

function remove() {
  info "Stopping and removing $CONTAINER_NAME"
  docker container stop "$CONTAINER_NAME"
  docker container rm "$CONTAINER_NAME"
}

function exec_bash() {
  docker exec \
      --interactive \
      --tty \
      "$CONTAINER_NAME" \
      /bin/bash
}

if [ $# -eq 0 ]; then
  compgen -A function | grep -Ev '^(fail|info|ok)'
  exit 0
fi
"$@"

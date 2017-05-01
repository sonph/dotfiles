#!/bin/bash

source common_utils.sh

IMAGE_NAME="sonph/transmission_img"
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
      --build-arg password=$password \
      ./ && \
      info "Listing images" && \
      docker image ls
}

function start() {
  mkdir config downloads 2>&1 > /dev/null
  info "Starting $CONTAINER_NAME"
  docker run \
      -d \
      --name=$CONTAINER_NAME \
      -v $PWD/config:/config \
      -v $PWD/downloads:/downloads \
      -p 9091:9091 \
      -p 51413:51413 \
      -p 51413:51413/udp \
      $IMAGE_NAME
  local status=$? && [[ $status -ne 0 ]] && return $status
  if command -v 2>&1 > /dev/null docker-machine; then
    info "Url: http://$(docker-machine ip):9091 (docker-machine)"
  else
    info "Url: http://localhost:9091"
  fi
}

function stop() {
  docker container stop $CONTAINER_NAME
}

function remove() {
  info "Stopping and removing $CONTAINER_NAME"
  docker container stop $CONTAINER_NAME
  docker container rm $CONTAINER_NAME
}

function exec_bash() {
  docker exec \
      --interactive \
      --tty \
      $CONTAINER_NAME \
      /bin/bash
}

if [ $# -eq 0 ]; then
  echo $(compgen -A function) | sed 's/\(fail\|info\|ok\) //g'
  exit 0
fi
$@


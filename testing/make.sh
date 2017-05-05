#!/bin/bash
# Run the tests in a local docker container, which runs the same travis test script.
# This script does the following:
#   - create a new test image with necessary software installed e.g. git
#   - remove existing containers, and create a new one for each test run
#   - mount the dotfiles directory and execute the travis test script
#   - if the test fails, drop into bash for debugging
# with these assumptions:
#   - docker is properly installed and running
#   - dotfiles is cloned to ~/.files
#   - script is invoked from .files

TESTING_DIR="$(dirname "$0")"
source "$TESTING_DIR/../bin/common_utils.sh"

DOCKER_CONTAINER_NAME='dotfiles_test_ctn'
DOCKER_IMAGE_NAME='dotfiles_test_img'

function build() {
  info "Building dotfiles test docker image"
  docker build ./ \
    -f dotfiles_test.Dockerfile \
    -t "$DOCKER_IMAGE_NAME"
}

function test() {
  if [[ "$(docker image ls | grep -ic "$DOCKER_IMAGE_NAME")" -lt 1 ]]; then
    info "Building test image"
    docker_build
  fi
  if [[ "$(docker container ls -a | grep -c "$DOCKER_CONTAINER_NAME")" -ge 1 ]]; then
    info "Stopping container "
    docker container stop $DOCKER_CONTAINER_NAME
    info "Removing container "
    docker container rm $DOCKER_CONTAINER_NAME
  fi
  info "Starting docker container..."
  docker run \
      --name $DOCKER_CONTAINER_NAME \
      --volume "$HOME/.files:/files" \
      --env TRAVIS_OS_NAME=linux \
      --interactive \
      --tty \
      $DOCKER_IMAGE_NAME
}

if [ $# -eq 0  ]; then
  compgen -A function | grep -Ev '^(fail|info|ok)'
  exit 0
fi
"$@"


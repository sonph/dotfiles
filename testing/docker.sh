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

TESTING_DIR=$(dirname $0)
source "$TESTING_DIR/../bin/common_utils.sh"

DOCKER_CONTAINER_NAME='dotfiles_test_container'
DOCKER_IMAGE_NAME='dotfiles_test_image'

# ubuntu:14.04 does not have git.
create_image() {
  info "Creating test container image"
  docker image pull ubuntu:14.04
  docker run --name creating_dotfiles_test_image \
      ubuntu:14.04 \
      bash -c "apt-get update -q && apt-get install -y git binutils gcc python2.7 python-dev python3-dev g++ g++-4.8 make"
  docker commit creating_dotfiles_test_image $DOCKER_IMAGE_NAME
  docker container rm creating_dotfiles_test_image
}

if [ "$IN_DOCKER" ]; then
  # As we're in the docker container, perform setup steps, then call travis-test.
  info "In Docker container"
  ln -s /files $HOME/.files
  pushd $HOME/.files
  # Run test script and drop into bash for debugging if it fails.
  ./testing/travis-test.sh || exec /bin/bash
else
  # We're still in the host. Create a new docker container, link volume and 
  # call this script.
  if [ $(docker image ls | grep -i $DOCKER_IMAGE_NAME | wc -l) -lt 1 ]; then
    create_image
  fi
  if [ $(docker container ls -a | grep $DOCKER_CONTAINER_NAME | wc -l) -ge 1 ]; then
    info "Stopping container "
    docker container stop $DOCKER_CONTAINER_NAME
    info "Removing container "
    docker container rm $DOCKER_CONTAINER_NAME
  fi
  info "Starting docker container..."
  docker run \
      --name $DOCKER_CONTAINER_NAME \
      --volume "$HOME/.files:/files" \
      --env IN_DOCKER=docker \
      --env TRAVIS_OS_NAME=linux \
      --interactive \
      --tty \
      $DOCKER_IMAGE_NAME:latest \
      bash -c '/files/testing/docker.sh'
fi

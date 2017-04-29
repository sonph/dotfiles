FROM debian:8

# This is to cache apt-get
RUN apt-get update -q
RUN apt-get install -y git binutils gcc python2.7 python-dev python3 python3-dev g++ make
RUN apt-get upgrade

RUN mkdir /files
RUN ln -s /files /root/.files
WORKDIR /root/.files

ENTRYPOINT ./testing/travis-test.sh || exec /bin/bash

VOLUME /files

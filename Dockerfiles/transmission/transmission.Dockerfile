# Simple Docker container with only transmission-daemon and web interface.
# Usage:
#   docker ...

# Debian 8 jessie.
FROM debian:8

ARG password=transmission-password

# Also store the password as a image label.
LABEL web_interface_password=$password

RUN apt-get update
RUN apt-get install -y transmission-cli transmission-daemon

COPY transmission.sh /
COPY settings.json /
RUN chmod u+x /transmission.sh
RUN /transmission.sh configure $password

ENTRYPOINT /transmission.sh start

EXPOSE 9091 51413
VOLUME /config /downloads


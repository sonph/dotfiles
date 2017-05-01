# Simple Docker container with only transmission-daemon and web interface.

# Debian 8 jessie.
FROM debian:8

ARG password=transmissionpassword

# Also store the password as a image label.
LABEL web_interface_password=$password

RUN apt-get update && \
    apt-get install -y transmission-cli transmission-daemon && \
    rm -rf /var/lib/apt/lists/*
COPY transmission.sh settings.json /
RUN chmod u+x /transmission.sh && \
    /transmission.sh configure $password
RUN mkdir /downloads && \
    chown debian-transmission /downloads

EXPOSE 9091 51413
VOLUME /config /downloads

CMD /transmission.sh start


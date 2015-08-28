FROM ubuntu:14.04

ENV REFRESHED_AT 08-24-2015

RUN apt-get update
RUN apt-get install -y zsh git vim tmux python3 gcc nodejs python-pip curl wget exuberant-ctags

RUN chsh -s /usr/bin/zsh root

RUN mkdir /root/code
WORKDIR /root/code
RUN git clone --recursive https://github.com/sonph/dotfiles
WORKDIR /root/code/dotfiles
RUN bash symlink.sh
RUN bash spf13-vim.docker.sh 2>&1 > /dev/null

WORKDIR /root
ENTRYPOINT ["/usr/bin/zsh"]
CMD []

EXPOSE 80
EXPOSE 8000
EXPOSE 8080
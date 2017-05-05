#!/bin/bash
# Utility script to work with youtube-dl.
# Usage: youtube-dl.sh download-audio-playlist "https://youtube.com/playlist?list=..."
#
# Note:
#   - Playlist must not be private (public or unlisted)
#   - Youtube-dl should be up to date before use (youtube-dl.sh update)
#
# Guide: https://github.com/rg3/youtube-dl

source common_utils.sh

function update() {
  info "Updating youtube-dl: youtube-dl -U"
  youtube-dl -U
}

function download_audio_playlist() {
  local playlist="${1}"
  info "MAKE SURE playlist is accessible through the url (public or unlisted)"
  if [[ -z "$playlist" || "$playlist" == "--help" ]]; then
    fail "Must provide a playlist url"
    echo "Usage: youtube-dl.sh download_audio_playlist \"https://youtube.com/playlist?list=...\" [output_dir]"
    return 1
  fi
  info "Playlist: $playlist"
  local output_dir=${2:-$(mktemp -d youtube-dl.sh.XXXX)}
  info "Output dir: $output_dir"

  update
  pushd "$output_dir"
  youtube-dl \
      --extract-audio \
      --audio-format mp3 \
      --audio-quality 2 \
      --add-metadata \
      --yes-playlist \
      "$playlist"
}

function install_mac() {
  # Youtube-dl can use either avconv or ffmpeg.
  # --prefer-avconv or --prefer-ffmpeg
  local cmd="brew install youtube-dl"
  info "Installing youtube-dl: $cmd"
  $cmd
}

if [ $# -eq 0 ]; then
  compgen -A function | grep -Ev '^(fail|info|ok)'
  exit 0
fi
"$@"


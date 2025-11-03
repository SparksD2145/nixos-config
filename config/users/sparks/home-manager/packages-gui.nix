{ inputs, pkgs, ... }:
with pkgs;
[
  vscode
  virt-manager
  remmina
  wl-clipboard

  # fun stuff
  obs-studio
  vlc
  moonlight-qt
  discord-ptb

  # video editing
  davinci-resolve
  ffmpeg
  incron # Cron-like daemon which handles filesystem events
]

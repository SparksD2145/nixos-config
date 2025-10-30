{ inputs, pkgs, ... }:
with pkgs;
[
  vscode
  virt-manager
  remmina

  # fun stuff
  obs-studio
  vlc
  moonlight-qt

  # video editing
  davinci-resolve
  ffmpeg
  incron # Cron-like daemon which handles filesystem events
]

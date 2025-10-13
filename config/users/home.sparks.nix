{ config, pkgs, lib, ... }:

{
  home.username = "sparks";
  home.homeDirectory = "/home/sparks";


  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    # archives
    zip
    xz
    unzip
    p7zip

    # utils
    ripgrep # recursively searches directories for a regex pattern
    jq # A lightweight and flexible command-line JSON processor
    eza # A modern replacement for ‘ls’
    fzf # A command-line fuzzy finder

    # networking tools
    mtr # A network diagnostic tool
    iperf3
    dnsutils  # `dig` + `nslookup`
    ldns # replacement of `dig`, it provide the command `drill`
    aria2 # A lightweight multi-protocol & multi-source command-line download utility
    socat # replacement of openbsd-netcat
    nmap # A utility for network discovery and security auditing
    ipcalc  # it is a calculator for the IPv4/v6 addresses

    # misc
    cowsay
    file
    which
    tree
    gnused
    gnutar
    gawk
    zstd
    gnupg
    parted
    sshpass

    # nix related
    #
    # it provides the command `nom` works just like `nix`
    # with more details log output
    nix-output-monitor
    nixfmt-rfc-style
    nil

    # productivity
    glow # markdown previewer in terminal

    btop  # replacement of htop/nmon
    iotop # io monitoring
    iftop # network monitoring

    # infra
    kubectl
    krew
    kubernetes-helm
    fluxcd
    sops
    age
    pre-commit
    yq
    ansible
    direnv
    go-task
    opentofu
    kustomize
    gitleaks
    nodePackages.prettier
    ipmitool
    fasd
    rclone
    gh
    glab
    uv
    vscode
    virt-manager
    remmina

    # fun stuff
    obs-studio

    # system call monitoring
    strace # system call monitoring
    ltrace # library call monitoring
    lsof # list open files

    # system tools
    sysstat
    lm_sensors # for `sensors` command
    ethtool
    pciutils # lspci
    usbutils # lsusb
  ];

  # basic configuration of git, please change to your own
  programs.git = {
    enable = true;
    userName = "Thomas Ibarra";
    userEmail = "hello@iwrite.software";
  };

  # starship - an customizable prompt for any shell
  programs.starship = {
    enable = true;
    # custom settings
    settings = {
      add_newline = false;
      aws.disabled = true;
      gcloud.disabled = true;
      line_break.disabled = true;
    };
  };

  # alacritty - a cross-platform, GPU-accelerated terminal emulator
  programs.alacritty = {
    enable = true;
    # custom settings
    settings = {
      env.TERM = "xterm-256color";
      font = {
        size = 12;
        draw_bold_text_with_bright_colors = true;
      };
      scrolling.multiplier = 5;
      selection.save_to_clipboard = true;
    };
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
    # TODO add your custom bashrc here
    bashrcExtra = ''
      export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin"
    '';

    # set some aliases, feel free to add more or remove some
    shellAliases = {
      k = "kubectl";
      urldecode = "python3 -c 'import sys, urllib.parse as ul; print(ul.unquote_plus(sys.stdin.read()))'";
      urlencode = "python3 -c 'import sys, urllib.parse as ul; print(ul.quote_plus(sys.stdin.read()))'";
    };
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ll = "ls -l";
      update = "sudo nixos-rebuild switch";
    };
    history.size = 10000;

    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [
        "git"
        "kubectl"
        "helm"
        "direnv"
        "fasd"
      ];
    };

    initContent = ''
      export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin";
      export PATH="$PATH:$HOME/.krew/bin"
    '';
  };

  programs.vim.enable = true;
  programs.vim.defaultEditor = true;
  programs.vim.plugins = [
    pkgs.vimPlugins.nerdtree
    pkgs.vimPlugins.vim-airline
    pkgs.vimPlugins.vim-fugitive
    pkgs.vimPlugins.vim-better-whitespace
    pkgs.vimPlugins.vim-colorschemes
    pkgs.vimPlugins.tabular
    pkgs.vimPlugins.syntastic
    pkgs.vimPlugins.ctrlp-vim
    pkgs.vimPlugins.emmet-vim
    pkgs.vimPlugins.editorconfig-vim
    pkgs.vimPlugins.vim-yaml
    pkgs.vimPlugins.ansible-vim
    pkgs.vimPlugins.vim-polyglot
  ];
  programs.vim.extraConfig = ''

    set nocompatible              " be iMproved, required
    filetype off                  " required

    " Us spaces instead of tabs
    set tabstop=8 softtabstop=0 expandtab shiftwidth=4 smarttab

    " Use syntax highlighting
    syntax on

    " NERDTree show hidden by default
    let NERDTreeShowHidden=1

    colorscheme evening

    set number relativenumber
  '';

  # The state version is required and should stay at the version you
  # originally installed.
  home.stateVersion = "25.05";
}

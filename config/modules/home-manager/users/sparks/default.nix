{
  inputs,
  pkgs,
  ...
}:

{
  home.username = "sparks";
  home.homeDirectory = "/home/sparks";

  # Packages that should be installed to the user profile.
  home.packages = import ./packages.nix { inherit inputs pkgs; };

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
      update = "sudo nixos-rebuild switch --flake .";
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

  programs.vim = {
    enable = true;
    defaultEditor = true;
    plugins = with pkgs; [
      vimPlugins.nerdtree
      vimPlugins.vim-airline
      vimPlugins.vim-fugitive
      vimPlugins.vim-better-whitespace
      vimPlugins.vim-colorschemes
      vimPlugins.tabular
      vimPlugins.syntastic
      vimPlugins.ctrlp-vim
      vimPlugins.emmet-vim
      vimPlugins.editorconfig-vim
      vimPlugins.vim-yaml
      vimPlugins.ansible-vim
      vimPlugins.vim-polyglot
    ];
    extraConfig = ''

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

  };

  # The state version is required and should stay at the version you
  # originally installed.
  home.stateVersion = "25.05";
}

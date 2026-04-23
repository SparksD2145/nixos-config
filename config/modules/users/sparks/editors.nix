{ pkgs, ... }:
{
  home-manager.users.sparks = {
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

    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;
      profiles.default.extensions = with pkgs.vscode-extensions; [
        vscodevim.vim
        redhat.vscode-yaml
        jnoortheen.nix-ide
        editorconfig.editorconfig
        ms-python.python
        ms-azuretools.vscode-docker
        visualstudioexptteam.vscodeintellicode
        eamodio.gitlens
        christian-kohler.path-intellisense
        hashicorp.terraform
      ];
    };
  };
}

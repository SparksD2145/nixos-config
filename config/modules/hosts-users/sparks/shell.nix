{ ... }:
{
  home-manager.users.sparks = {

    # Enable direnv
    programs.direnv.enable = true;
    programs.direnv.nix-direnv.enable = true;

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

    programs.bash = {
      enable = true;
      enableCompletion = true;
      bashrcExtra = ''
        export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin"
      '';

      # set some aliases, feel free to add more or remove some
      shellAliases = {
        k = "kubectl";
        code = "codium";
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
        ll = "ls -lha";
        k = "kubectl";
        code = "codium";
        update = "sudo nixos-rebuild switch --flake 'github:SparksD2145/nixos-config'";
        fluxupdate = "git add .; git commit --amend --no-edit; git push -f; git push gitlab -f; flux reconcile kustomization flux-system --with-source;";

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
        alias vlang=`whereis v -b | awk '{ print $2 }'`
      '';
    };
  };
}

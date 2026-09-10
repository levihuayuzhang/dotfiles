{ config, pkgs, ... }:

{
  home.username = "zhy";
  home.homeDirectory = "/home/zhy";

  # home.sessionVariables = {
  #   http_proxy = "http://127.0.0.1:7890";
  #   https_proxy = "http://127.0.0.1:7890";
  #   all_proxy = "socks5h://127.0.0.1:7891";
  #
  #   HTTP_PROXY = "http://127.0.0.1:7890";
  #   HTTPS_PROXY = "http://127.0.0.1:7890";
  #   ALL_PROXY = "socks5h://127.0.0.1:7891";
  # };

  programs.git = {
    enable = true;

    settings = {
      user = {
        name = "Huayu Zhang";
        email = "zhanghuayu.dev@gmail.com";
        signingkey = "71C9DEC83C653F60";
      };

      commit = {
        gpgsign = true;
      };

      tag = {
        gpgSign = true;
      };

      # gpg = {
      #   format = "openpgp";
      # };
    };
  };

  programs.bash = {
    enable = true;
    shellAliases = {
      btw = "echo I use nixos, btw";
    };
  };

  programs.zsh = {
    enable = true;

    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [
        "git"
        "sudo"
        "docker"
      ];
    };

    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    initContent = ''
      export GPG_TTY=$(tty)
    '';
    shellAliases = {
      l = "eza -la --icons";
      ls = "eza --icons";
      ll = "eza -l --icons";
      la = "eza -a --icons";
      grep = "grep --color=auto";
      nfu = "nix flake update --flake /home/zhy/projects/dotfiles/nixos/etc/nixos";
      nrs = "sudo nixos-rebuild switch --flake /home/zhy/projects/dotfiles/nixos/etc/nixos#levi-pc";
    };
  };

  dconf = {
    enable = true;

    settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };

      "org/gnome/desktop/wm/preferences" = {
        button-layout = "menu:";
      };
    };

  };

  home.stateVersion = "26.05";
}

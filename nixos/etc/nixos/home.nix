{ config, pkgs, ... }:

{
  home.username = "zhy";
  home.homeDirectory = "/home/zhy";

  programs.git = {
    enable = true;

    settings = {
      user = {
        name = "Huayu Zhang";
        email = "zhanghuayu.dev@gmail.com";
      };
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

    shellAliases = {
      grep = "grep --color=auto";
      nrs = "sudo nixos-rebuild switch --flake /home/zhy/projects/dotfiles/nixos/etc/nixos#levi-pc";
    };
  };

  home.stateVersion = "26.05";
}

{ config, pkgs, ...}:

{
    home.username = "zhy";
    home.homeDirectory = "/home/zhy";
    programs.git.enable = true;
    home.stateVersion = "26.05";
    programs.bash = {
        enable = true;
        shellAliases = {
            btw = "echo I use nixos, btw";
        };
    };
}

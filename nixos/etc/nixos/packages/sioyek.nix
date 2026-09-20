# https://github.com/ahrm/sioyek/issues/1283#issuecomment-3012097149

{ pkgs, ... }:

let
  sioyek = pkgs.symlinkJoin {
    name = "sioyek";
    paths = [ pkgs.sioyek ];
    buildInputs = [ pkgs.makeWrapper ];

    postBuild = ''
      wrapProgram $out/bin/sioyek \
        --set QT_QPA_PLATFORM xcb
    '';
  };
in
{
  environment.systemPackages = [
    sioyek
  ];
}

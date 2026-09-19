# fix niri screen sharing for wemeet.
# https://linux.do/t/topic/1831235

{ pkgs, ... }:

let
  wemeet = pkgs.symlinkJoin {
    name = "wemeet";

    paths = [
      pkgs.wemeet
    ];

    nativeBuildInputs = [
      pkgs.makeWrapper
    ];

    postBuild = ''
      rm -f $out/bin/wemeet

      displayProbe='
        if [ -z "''${DISPLAY-}" ]; then
          for x_sock in /tmp/.X11-unix/X*; do
            if [ -S "$x_sock" ]; then
              export DISPLAY=":''${x_sock##*/X}"
              break
            fi
          done
        fi
      '

      makeWrapper ${pkgs.wemeet}/bin/wemeet-xwayland $out/bin/wemeet \
        --run "$displayProbe" \
        --set __EGL_VENDOR_LIBRARY_FILENAMES \
          ${pkgs.mesa}/share/glvnd/egl_vendor.d/50_mesa.json
    '';
  };
in
{
  environment.systemPackages = [
    wemeet
  ];
}

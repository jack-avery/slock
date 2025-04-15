{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
  };

  outputs = { self, flake-utils, nixpkgs }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = (import nixpkgs) {
          inherit system;
        };
      in rec {
        defaultPackage = pkgs.stdenv.mkDerivation {
          name = "slock";

          nativeBuildInputs = with pkgs; [
            pkg-config
          ];

          buildInputs = with pkgs; [
            libxcrypt
            xorg.libX11
            xorg.libXext
            xorg.libXrandr
            xorg.xrandr
          ];

          src = ./.;

          buildPhase = ''
            make
          '';

          installPhase = ''
            mkdir -p $out/bin
            cp slock $out/bin/slock
          '';
        };
      }
    );
}

{ pkgs ? (import (builtins.fetchGit {
  url = "https://github.com/NixOS/nixpkgs.git";
  ref = "nixos-20.09";
  rev = "19db3e5ea2777daa874563b5986288151f502e27";
}) {}) }:

pkgs.stdenv.mkDerivation rec {
  pname = "mtext";
  version = "1.0.0";

  src = ./.;

  nativeBuildInputs = [ pkgs.makeWrapper ];

  buildPhase = ''
    patchShebangs mtext.sh
  '';

  installPhase = ''
    mkdir -p $out/bin
    mv mtext.sh $out/bin/mtext
  '';

  postFixup = ''
    wrapProgram $out/bin/mtext --prefix PATH : ${pkgs.stdenv.lib.makeBinPath [
      pkgs.mblaze
    ]}
  '';

  meta = with pkgs.stdenv.lib; {
    description = "Send quick and easy text messages with `mblaze`";
  };
}
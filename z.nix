{ pkgs }:

# z - https://github.com/rupa/z
pkgs.stdenv.mkDerivation {
  name = "z";
  src = pkgs.fetchFromGitHub {
    owner = "rupa";
    repo = "z";
    rev = "9f76454b32c0007f20b0eae46d55d7a1488c9df9";
    sha256 = "0qywf8pdrlp43b6c1pgyl51501dhx4f672dk1b0lvdlkj37d4pgz";
  };
  dontBuild = true;
  installPhase = ''
    mkdir -p $out/bin 
    mkdir -p $out/share/man/man1
    cp z.sh $out/bin
    cp z.1 $out/share/man/man1
  '';
}

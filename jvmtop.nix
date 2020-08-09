{ stdenv, fetchurl, jdk8, runtimeShell }:

# jvmtop
# NOTE this currently doesn't work because it relies on features like management-agent.jar
# from jdk8

stdenv.mkDerivation {
  name = "jvmtop";
  src = fetchurl {
    url = "https://github.com/patric-r/jvmtop/releases/download/0.8.0/jvmtop-0.8.0.tar.gz";
    sha256 = "1i18q46s1s4vlpqb3yl7wnlcmnqd9x60nllnn58hlh0b4icq3ppr";
  };
  unpackPhase = ''
    mkdir -p $out/opt/
    tar xf $src -C $out/opt/
  '';
  dontBuild = true;
  buildInputs = [ jdk8 ];
  installPhase = ''
    mkdir -p $out/bin 
    cat > "$out/bin/jvmtop" <<EOF
    #!${runtimeShell}
    ${jdk8.jre}/bin/java -cp "$out/opt/jvmtop.jar:${jdk8}/lib/tools.jar" \
        -Djava.home=${jdk8}/jre com.jvmtop.JvmTop "\$@"
      exit \$?
    EOF
    chmod +x $out/bin/jvmtop
  '';
}

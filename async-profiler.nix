{ stdenv, fetchurl }:

# async-profiler - jvm profiler that can produce flamegraphs,
# ex:
#   async-profiler -d 5 -f ./flamegraph.svg 63226

stdenv.mkDerivation {
  name = "async-profiler";
  src = fetchurl {
    url = "https://github.com/jvm-profiling-tools/async-profiler/releases/download/v1.7.1/async-profiler-1.7.1-macos-x64.tar.gz";
    sha256 = "1ydmysyrbhsnk55kgwracpdii3mdfb58mdbzpns8qd0wmrjlczj5";
  };
  # this needs to be set, otherwise the folder "build" in in the unpacked
  # tarball is used as the source root
  sourceRoot = ".";
  installPhase = ''
    mkdir -p $out/bin $out/opt
    cp ./profiler.sh $out/bin/async-profiler
    substituteInPlace \
      $out/bin/async-profiler \
      --replace 'SCRIPT_DIR=$(dirname "$(abspath "$0")")' SCRIPT_DIR=$out/opt/
    cp -r build $out/opt/
  '';
}

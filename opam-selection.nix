### This file is generated by opam2nix.

self:
let
    lib = self.lib;
    pkgs = self.pkgs;
    repoPath = self.repoPath;
    repos = 
    {
      opam-repository = 
      rec {
        fetch = 
        {
          owner = "ocaml";
          repo = "opam-repository";
          rev = "9722f20a60d1cc64ef3e51a7b1d9277fe9629419";
          sha256 = "0w5haqslldygypaplla0cqxp7rbm9c1p8rjyfcpjp5684wvnnbis";
        };
        src = (pkgs.fetchFromGitHub) fetch;
      };
    };
    selection = self.selection;
in
{
  format-version = 4;
  ocaml-version = "4.12.0";
  repos = repos;
  selection = 
  {
    base-threads = 
    {
      opamInputs = {
      };
      opamSrc = repoPath (repos.opam-repository.src) 
      {
        hash = "sha256:1c4bpyh61ampjgk5yh3inrgcpf1z1xv0pshn54ycmpn4dyzv0p2x";
        package = "packages/base-threads/base-threads.base";
      };
      pname = "base-threads";
      src = null;
      version = "base";
    };
    base-unix = 
    {
      opamInputs = {
      };
      opamSrc = repoPath (repos.opam-repository.src) 
      {
        hash = "sha256:0mpsvb7684g723ylngryh15aqxg3blb7hgmq2fsqjyppr36iyzwg";
        package = "packages/base-unix/base-unix.base";
      };
      pname = "base-unix";
      src = null;
      version = "base";
    };
    biniou = 
    {
      opamInputs = 
      {
        dune = selection.dune;
        easy-format = selection.easy-format;
        ocaml = selection.ocaml;
      };
      opamSrc = repoPath (repos.opam-repository.src) 
      {
        hash = "sha256:12ykyqa9piw1gny1flsi43qph411alzsm3rr8cgs5ap4drk3xbrd";
        package = "packages/biniou/biniou.1.2.1";
      };
      pname = "biniou";
      src = pkgs.fetchurl 
      {
        sha256 = "0da3m0g0dhl02jfynrbysjh070xk2z6rxcx34xnqx6ljn5l6qm1m";
        url = "https://github.com/mjambon/biniou/releases/download/1.2.1/biniou-1.2.1.tbz";
      };
      version = "1.2.1";
    };
    cppo = 
    {
      opamInputs = 
      {
        base-unix = selection.base-unix;
        dune = selection.dune;
        ocaml = selection.ocaml;
      };
      opamSrc = repoPath (repos.opam-repository.src) 
      {
        hash = "sha256:1kga0i21r60914qcjnxaxx03p6vj476j4sgcfnndcawycsip8zix";
        package = "packages/cppo/cppo.1.6.7";
      };
      pname = "cppo";
      src = pkgs.fetchurl 
      {
        sha256 = "17ajdzrnmnyfig3s6hinb56mcmhywbssxhsq32dz0v90dhz3wmfv";
        url = "https://github.com/ocaml-community/cppo/releases/download/v1.6.7/cppo-v1.6.7.tbz";
      };
      version = "1.6.7";
    };
    csexp = 
    {
      opamInputs = 
      {
        dune = selection.dune;
        ocaml = selection.ocaml;
      };
      opamSrc = repoPath (repos.opam-repository.src) 
      {
        hash = "sha256:0yhsha07yvqkv0g891i3b34gsvml7q2a0l1fxkhisiq0i08smmg2";
        package = "packages/csexp/csexp.1.5.1";
      };
      pname = "csexp";
      src = pkgs.fetchurl 
      {
        sha256 = "00mc19f89pxpmjl62862ya5kjcfrl8rjzvs00j05h2m9bw3f81fn";
        url = "https://github.com/ocaml-dune/csexp/releases/download/1.5.1/csexp-1.5.1.tbz";
      };
      version = "1.5.1";
    };
    dot-merlin-reader = 
    {
      opamInputs = 
      {
        csexp = selection.csexp;
        dune = selection.dune;
        ocaml = selection.ocaml;
        ocamlfind = selection.ocamlfind;
        result = selection.result;
        yojson = selection.yojson;
      };
      opamSrc = repoPath (repos.opam-repository.src) 
      {
        hash = "sha256:14w8xfc8nbkkrcqzsx8ql9dar1ni9vh7wfg6pavlprjjzq3vhyll";
        package = "packages/dot-merlin-reader/dot-merlin-reader.4.1";
      };
      pname = "dot-merlin-reader";
      src = pkgs.fetchurl 
      {
        sha256 = "1kg765h6gqq5ffa1fdvm0kpa9w922y3af804ags5ssk4p1pnv8ql";
        url = "https://github.com/ocaml/merlin/releases/download/v4.1/dot-merlin-reader-v4.1.tbz";
      };
      version = "4.1";
    };
    dune = 
    {
      opamInputs = 
      {
        base-threads = selection.base-threads;
        base-unix = selection.base-unix;
        ocaml = selection.ocaml or null;
        ocamlfind-secondary = selection.ocamlfind-secondary or null;
      };
      opamSrc = repoPath (repos.opam-repository.src) 
      {
        hash = "sha256:0i9gliphdz2gm6y7x2a1s1sd9wnq31sj84r3bpwd6frykd9xlv9v";
        package = "packages/dune/dune.2.8.5";
      };
      pname = "dune";
      src = pkgs.fetchurl 
      {
        sha256 = "0a9n8ilsi3kyx5xqvk5s7iikk6y3pkpm5mvsn5za5ivlzf1i40br";
        url = "https://github.com/ocaml/dune/releases/download/2.8.5/dune-2.8.5.tbz";
      };
      version = "2.8.5";
    };
    dune-build-info = 
    {
      opamInputs = {
                     dune = selection.dune;
      };
      opamSrc = repoPath (repos.opam-repository.src) 
      {
        hash = "sha256:0sr7jfcbqsfcyskf8w9hkirl9kmysv30s722a24j94vrw0mwgfi2";
        package = "packages/dune-build-info/dune-build-info.2.8.5";
      };
      pname = "dune-build-info";
      src = pkgs.fetchurl 
      {
        sha256 = "0a9n8ilsi3kyx5xqvk5s7iikk6y3pkpm5mvsn5za5ivlzf1i40br";
        url = "https://github.com/ocaml/dune/releases/download/2.8.5/dune-2.8.5.tbz";
      };
      version = "2.8.5";
    };
    easy-format = 
    {
      opamInputs = 
      {
        dune = selection.dune;
        ocaml = selection.ocaml;
      };
      opamSrc = repoPath (repos.opam-repository.src) 
      {
        hash = "sha256:1zahpwp0021xygbwpygrrwa5g65qq6dfqngckb3823ybc6l79lva";
        package = "packages/easy-format/easy-format.1.3.2";
      };
      pname = "easy-format";
      src = pkgs.fetchurl 
      {
        sha256 = "09hrikx310pac2sb6jzaa7k6fmiznnmhdsqij1gawdymhawc4h1l";
        url = "https://github.com/mjambon/easy-format/releases/download/1.3.2/easy-format-1.3.2.tbz";
      };
      version = "1.3.2";
    };
    ocaml = 
    {
      opamInputs = 
      {
        ocaml-base-compiler = selection.ocaml-base-compiler or null;
        ocaml-config = selection.ocaml-config;
        ocaml-system = selection.ocaml-system or null;
        ocaml-variants = selection.ocaml-variants or null;
      };
      opamSrc = repoPath (repos.opam-repository.src) 
      {
        hash = "sha256:0xrq7j9zfynk524j69i3and0mqgi32wav751s4cqc1q7pqm47xpc";
        package = "packages/ocaml/ocaml.4.12.0";
      };
      pname = "ocaml";
      src = null;
      version = "4.12.0";
    };
    ocaml-base-compiler = 
    {
      opamInputs = {
      };
      opamSrc = repoPath (repos.opam-repository.src) 
      {
        hash = "sha256:0gf3z9qmi976x4iwndfslcim50ickla52x9fp94aqxrgvsy1ypn7";
        package = "packages/ocaml-base-compiler/ocaml-base-compiler.4.12.0";
      };
      pname = "ocaml-base-compiler";
      src = pkgs.fetchurl 
      {
        sha256 = "0i37laikik5vwydw1cwygxd8xq2d6n35l20irgrh691njlwpmh5d";
        url = "https://github.com/ocaml/ocaml/archive/4.12.0.tar.gz";
      };
      version = "4.12.0";
    };
    ocaml-config = 
    {
      opamInputs = 
      {
        ocaml-base-compiler = selection.ocaml-base-compiler or null;
        ocaml-system = selection.ocaml-system or null;
        ocaml-variants = selection.ocaml-variants or null;
      };
      opamSrc = repoPath (repos.opam-repository.src) 
      {
        hash = "sha256:0h0hgqq9mbywvqygppfdc50gf9ss8a97l4dgsv3hszmzh6gglgrg";
        package = "packages/ocaml-config/ocaml-config.2";
      };
      pname = "ocaml-config";
      src = null;
      version = "2";
    };
    ocaml-lsp-server = 
    {
      opamInputs = 
      {
        csexp = selection.csexp;
        dot-merlin-reader = selection.dot-merlin-reader;
        dune = selection.dune;
        dune-build-info = selection.dune-build-info;
        ocaml = selection.ocaml;
        ppx_yojson_conv_lib = selection.ppx_yojson_conv_lib;
        result = selection.result;
        yojson = selection.yojson;
      };
      opamSrc = "ocaml-lsp-server.opam";
      pname = "ocaml-lsp-server";
      src = self.directSrc "ocaml-lsp-server";
      version = "development";
    };
    ocamlfind = 
    {
      opamInputs = 
      {
        graphics = selection.graphics or null;
        ocaml = selection.ocaml;
      };
      opamSrc = repoPath (repos.opam-repository.src) 
      {
        hash = "sha256:11avrzm0gdc6mz7dazr8q18ir5429ckc36s2mv0l8722znq8lc3k";
        package = "packages/ocamlfind/ocamlfind.1.9.1";
      };
      pname = "ocamlfind";
      src = pkgs.fetchurl 
      {
        sha256 = "1qhgk25avmz4l4g47g8jvk0k1g9p9d5hbdrwpz2693a8ajyvhhib";
        url = "http://download.camlcity.org/download/findlib-1.9.1.tar.gz";
      };
      version = "1.9.1";
    };
    ppx_yojson_conv_lib = 
    {
      opamInputs = 
      {
        dune = selection.dune;
        ocaml = selection.ocaml;
        yojson = selection.yojson;
      };
      opamSrc = repoPath (repos.opam-repository.src) 
      {
        hash = "sha256:009x6jphkby3dqzcjafg9fyv4jlnf50bx23gy290m1cqs1mr1d89";
        package = "packages/ppx_yojson_conv_lib/ppx_yojson_conv_lib.v0.14.0";
      };
      pname = "ppx_yojson_conv_lib";
      src = pkgs.fetchurl 
      {
        sha256 = "1f1530pvyg05zwi83iwrk3v207w316wlljikwyl9ahjh24lsja46";
        url = "https://ocaml.janestreet.com/ocaml-core/v0.14/files/ppx_yojson_conv_lib-v0.14.0.tar.gz";
      };
      version = "v0.14.0";
    };
    result = 
    {
      opamInputs = 
      {
        dune = selection.dune;
        ocaml = selection.ocaml;
      };
      opamSrc = repoPath (repos.opam-repository.src) 
      {
        hash = "sha256:1c7lw8dbchllz3rl801xwpm82r427vnrv7b7kqh0gwjglya50y28";
        package = "packages/result/result.1.5";
      };
      pname = "result";
      src = pkgs.fetchurl 
      {
        sha256 = "0cpfp35fdwnv3p30a06wd0py3805qxmq3jmcynjc3x2qhlimwfkw";
        url = "https://github.com/janestreet/result/releases/download/1.5/result-1.5.tbz";
      };
      version = "1.5";
    };
    yojson = 
    {
      opamInputs = 
      {
        biniou = selection.biniou;
        cppo = selection.cppo;
        dune = selection.dune;
        easy-format = selection.easy-format;
        ocaml = selection.ocaml;
      };
      opamSrc = repoPath (repos.opam-repository.src) 
      {
        hash = "sha256:1vxmg1yiwh1wgxwwqzfrvaaff4wxanakq2yap1s2x3h54fqakkza";
        package = "packages/yojson/yojson.1.7.0";
      };
      pname = "yojson";
      src = pkgs.fetchurl 
      {
        sha256 = "1iich6323npvvs8r50lkr4pxxqm9mf6w67cnid7jg1j1g5gwcvv5";
        url = "https://github.com/ocaml-community/yojson/releases/download/1.7.0/yojson-1.7.0.tbz";
      };
      version = "1.7.0";
    };
  };
}


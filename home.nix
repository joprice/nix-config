{ config, pkgs, pkgsPath, lib, ... }:
let
  #crate2nix = import (builtins.fetchTarball "https://github.com/kolloch/crate2nix/tarball/e07af104b8e41d1cd7e41dc7ac3fdcdf4953efae") { };
  crate2nix = import (builtins.fetchTarball "https://github.com/lopsided98/crate2nix/tarball/d0b41938906c2fcaf86ae0b5b5a5d0d738ba1fff") {};
  async-profiler = pkgs.callPackage ./async-profiler.nix {};
  # git checkout with skim https://github.com/lotabout/skim
  git-cof =
    pkgs.writeShellScriptBin "git-cof" ''
      export PATH=${pkgs.lib.makeBinPath [ pkgs.git pkgs.skim ]}:$PATH
      git for-each-ref --format='%(refname:short)' refs/heads | sk | xargs git checkout
    '';
  idea =
    pkgs.writeShellScriptBin "idea" ''
      open -na "IntelliJ IDEA CE.app" --args "$@"
    '';
  # Find and delete branches that were squash-merged
  git-delete-squashed =
    pkgs.writeShellScriptBin "git-delete-squashed" (lib.fileContents ./delete-squashed.sh);
  haskell = with pkgs; haskellPackages.ghcWithPackages (
    pkgs: [
      haskellPackages.pretty-simple
    ]
  );
  z = pkgs.callPackage ./z.nix {};
  ocamlPackages = pkgs.ocaml-ng.ocamlPackages_4_12;
  ocaml-lsp = pkgs.callPackage ./ocaml-lsp.nix {
    inherit ocamlPackages;
  };
  # install sbt with scala native at different path?
  #sbt = pkgs.sbt-with-scala-native;#.override { jre = pkgs.jdk11; };
  # TODO: how to override jre globally?
  sbt = pkgs.sbt.override { jre = pkgs.jdk11; };
  scala = pkgs.scala;
  #scala = (pkgs.callPackage "${pkgsPath}/pkgs/development/compilers/scala/2.x.nix" { jre = pkgs.jdk11; }).scala_2_13;
  visualvm = pkgs.visualvm.override { jdk = pkgs.jdk11; };
  mill = pkgs.mill.override { jre = pkgs.jdk11; };
  leiningen = pkgs.leiningen.override { jdk = pkgs.jdk11; };
  # NOTE some android manager tooling fails on jdk11, so this needs to be jdk8 for android tasks
  jdk = pkgs.jdk11;
  obelisk = (import (builtins.fetchTarball "https://github.com/obsidiansystems/obelisk/archive/11beb6e8cd2419b2429925b76a98f24035e40985.tar.gz") {}).command;
  cabal-project-vim = pkgs.vimUtils.buildVimPlugin {
    name = "cabal-project-vim";
    src = pkgs.fetchFromGitHub {
      owner = "vmchale";
      repo = "cabal-project-vim";
      rev = "0d41e7e41b1948de84847d9731023407bf2aea04";
      sha256 = "15rn54wspy55v9lw3alhv5h9b7sv6yi6az9gzzskzyim76ka0n4g";
    };
  };
  vim-capnp = pkgs.vimUtils.buildVimPlugin {
    name = "vim-capnp";
    src = pkgs.fetchFromGitHub {
      owner = "cstrahan";
      repo = "vim-capnp";
      rev = "954202e2c6c1cb9185082de8ddb7f2823a9d1206";
      sha256 = "02nwxibfq1ddl3idms29c73b06rc5gpimdasfnn4pdafd7mhil7a";
    };
  };
  easy-ps = import
    (
      pkgs.fetchFromGitHub {
        owner = "justinwoo";
        repo = "easy-purescript-nix";
        rev = "eb64583e3e15749b3ae56573b2aebbaa9cbab4eb";
        sha256 = "0hr7smk7avdgc5nm1r3drq91j1hf8wimp7sg747832345c8vq19a";
      }
    )
    {
      inherit pkgs;
    };
  coc-sourcekit = pkgs.vimUtils.buildVimPluginFrom2Nix {
    name = "coc-sourcekit";
    src = pkgs.fetchFromGitHub {
      owner = "klaaspieter";
      repo = "coc-sourcekit";
      rev = "c3a69580042353dcf31e0a48141d02ffaa353b29";
      sha256 = "0qa64pizjma3zi4lcpbazravm5m60qd0sk3c8ds3z4y9dnjfmq21";
    };
  };
  coc-jedi = pkgs.vimUtils.buildVimPluginFrom2Nix {
    name = "coc-jedi";
    src = pkgs.fetchFromGitHub {
      owner = "pappasam";
      repo = "coc-jedi";
      rev = "2c07ed71d6759ca2319559e5921e08eb5d46f83e";
      sha256 = "0vn4nqhrzvdkndz13cdpjx8bzjcq5276cw5m9j35lxxggsq1bl0c";
    };
  };
  vim-swift = pkgs.vimUtils.buildVimPlugin {
    name = "vim-swift";
    src = pkgs.fetchFromGitHub {
      owner = "bumaociyuan";
      repo = "vim-swift";
      rev = "76dd8b90aec0e934e5a9c524bba9327436d54348";
      sha256 = "150sszxlgfn03yhmpjsivn2xxmrpjjzahc0ikc6j8b49ssjf6cd7";
    };
  };
  vim-swift-format = pkgs.vimUtils.buildVimPlugin {
    name = "vim-swift-format";
    src = pkgs.fetchFromGitHub {
      owner = "tokorom";
      repo = "vim-swift-format";
      rev = "2984712722b3ba16d06c2970e861196039b94dbe";
      sha256 = "0v90qx40nk2zkxf8n0qm776ny81i255z4ns35n59kxvixmj73042";
    };
  };
  coc-kotlin = pkgs.vimUtils.buildVimPlugin {
    name = "coc-kotlin";
    src = pkgs.fetchFromGitHub {
      owner = "weirongxu";
      repo = "coc-kotlin";
      rev = "b13c9912f2f651f65014ae2a8b73040047956e74";
      sha256 = "1bdix5c9bqp2j07p9fvcs3aghmahah7gnibb6nkb32mz6m5z0672";
    };
    buildPhase = ''
      touch .yarnrc
      ${pkgs.nodejs-12_x}/bin/npm --scripts-prepend-node-path run build
    '';
  };
  vim-markdown-preview = pkgs.vimUtils.buildVimPlugin {
    name = "vim-markdown-preview";
    src = pkgs.fetchFromGitHub {
      owner = "iamcco";
      repo = "markdown-preview.nvim";
      rev = "e5bfe9b89dc9c2fbd24ed0f0596c85fd0568b143";
      sha256 = "0bfkcfjqg2jqm4ss16ks1mfnlnpyg1l4l18g7pagw1dfka14y8fg";
    };
    buildPhase = ''
      touch .yarnrc
      ${pkgs.yarn}/bin/yarn --no-default-rc --disable-pnp --pure-lockfile install
    '';
  };
  bazel = pkgs.symlinkJoin {
    name = "bazel";
    paths = [ pkgs.bazelisk ];
    postBuild = "ln $out/bin/bazelisk $out/bin/bazel";
  };
in
{
  programs.home-manager.enable = true;
  home.username = "josephprice";
  home.homeDirectory = "/Users/josephprice";
  # TODO: use machines to make this relative? or other way to make dynamic?
  #home.username = "joseph";
  #home.homeDirectory = "/home/joseph";
  home.stateVersion = "21.05";
  # TODO: exclude df
  home.packages = with pkgs; [
    #bitcoin
    alacritty
    async-profiler
    autoconf
    awscli
    bazel
    bat
    cabal-install
    #ccls
    # not working https://github.com/NixOS/nixpkgs/issues/132049
    #cocoapods
    #crate2nix
    cabal2nix
    cachix
    clang-tools
    clojure
    cmake
    coreutils
    cue
    gitAndTools.delta
    dhall
    dhall-json
    easy-ps.purs
    easy-ps.psc-package
    easy-ps.spago
    easy-ps.pscid
    #flow
    git-cof
    git-delete-squashed
    github-cli
    gnupg
    go
    gradle
    graphviz
    gron
    haskell
    htop
    idea
    istioctl
    jdk
    joker
    loc
    nim
    jq
    kubectl
    kubectx
    # TODO: restrict to non-darwin?
    # unixtools.netstat
    leiningen
    libbitcoin-explorer
    loc
    maven
    mill
    niv
    nixpkgs-fmt
    nix-index
    nodePackages.node2nix
    nodePackages.esy
    nushell
    #nodejs-12_x
    #obelisk
    ocaml
    ocaml-lsp.ocaml-lsp-server
    ocaml-lsp.opam2nixResolve
    ocamlPackages.utop
    pstree
    ripgrep # rg - faster grep
    rlwrap
    rmlint
    rnix-lsp
    rustup
    rust-analyzer
    sbt
    scala
    stack
    skim
    telnet
    tree
    #visualvm
    vscode
    yarn
    z
    zlib
    nodePackages.bower
    libiconv
    xcpretty
    #websocat
    watchman
    #xquartz
    fswatch
    upx
    wrk
    gnuplot
    #micronaut
    #graalvm11-ce
    ioping
    openssl.out
    openssl.dev
    pkg-config
    hound
    #qemu
    #wasmer
    rust-analyzer
    nim
    tokei
    procs
    figlet
  ];
  #programs.opam = {
  #  enable = true;
  #};
  nixpkgs.config.allowUnfree = true;
  programs.neovim = with pkgs.vimPlugins; {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    # needed by coc-nvim
    withNodeJs = true;
    extraConfig = lib.fileContents ./vimrc;
    plugins = [
      # these don't work for some reason
      #vim-swift
      vim-swift-format
      #vim-markdown-preview
      #coc-sourcekit
      ale
      #coc-kotlin
      coc-metals
      coc-nvim
      # this server crashes on start
      coc-java
      coc-jedi
      coc-json
      coc-prettier
      coc-tsserver
      coc-rust-analyzer
      ctrlp
      ghcid
      #gitgutter
      psc-ide-vim
      vim-airline
      vim-airline-themes
      vim-polyglot
      vim-capnp
      cabal-project-vim
      zenburn
      # coment out with double ctrl+/ or gcc
      tcomment_vim
    ];
  };
  programs.git = {
    enable = true;
    userName = "Joseph Price";
    userEmail = "pricejosephd@gmail.com";
    aliases = {
      s = "status";
      co = "checkout";
      d = "diff";
      merged = "branch --merged";
      recent = "for-each-ref --sort=committerdate refs/heads/ --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(color:red)%(objectname:short)%(color:reset) - %(contents:subject) - %(authorname) (%(color:green)%(committerdate:relative)%(color:reset))'";
      lg = "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
      bclean = "!f() { git branch --merged master | grep -v '^\\*' | xargs -n 1 git branch -d; }; f";
    };
    extraConfig = {
      pull.ff = "only";
      # add fixup!
      rebase.autosquash = true;
      url = {
        "git@github.com:" = {
          insteadOf = "https://github.com/";
        };
        "git://" = {
          insteadOf = "https://";
        };
      };
    };
    delta.enable = true;
    ignores = [
      "*.swo"
      "*.swp"
      ".DS_Store"
      ".bloop/"
      ".idea/"
      ".metals/"
      ".vscode/*"
      "!.vscode/settings.json"
      "_esy/"
      "metals.sbt"
      "vim.log"
    ];
  };
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    history.extended = true;
    shellAliases = {
      cat = "bat";
      vi = "nvim";
      vim = "nvim";
      nixgc = "nix-collect-garbage -d";
      nixq = "nix-env -qaP";
      # TODO: this alias works around df only showing the nix volume when used from nix
      df = "/bin/df";
      # prints contents of paths on separate lines
      path = '' echo - e ''${PATH // :/\\n}'';
      # -I ignores binary files
      grep = "grep --color -I";
      ips = "ifconfig | awk '\$1 == \"inet\" {print \$2}'";
      hup = "home-manager switch && exec $SHELL";
      vim-debug = "vim -V9vim.log main.cpp";
      ls = "ls --color=auto";
      gh-pr = "gh pr create --fill";
    };
    oh-my-zsh = {
      enable = true;
      plugins = [
        "timer"
        "git-extras"
        "git"
        "gitfast"
        "github"
      ];
      theme = "robbyrussell";
    };
    initExtra = ''
      set -o vi
      bindkey "^?" backward-delete-char
      . ${z}/bin/z.sh
      unsetopt AUTO_CD
      export PATH=$HOME/.local/bin:$PATH
      nix-build-nodirenv() {
        pushd /; popd;
      }
    '';
  };
  home.sessionVariables = {
    # See https://github.com/direnv/direnv/issues/203#issuecomment-189873955
    DIRENV_LOG_FORMAT = "";
    #JAVA_HOME = "${pkgs.jdk.home}";
    LESS = "-RFX";
    EDITOR = "nvim";
    #OPENSSL_PREFIX = pkgs.openssl.dev;
    OPENSSL_PREFIX = pkgs.buildEnv {
      name = "openssl-combined";
      paths = with pkgs; [ openssl openssl.out openssl.dev ];
    };
  };
  home.file.".sbt/1.0/plugins/plugins.sbt".source = ./plugins.sbt;
  home.file.".config/nvim/coc-settings.json".source = ./coc-settings.json;
  programs.direnv = {
    enable = true;
    #enableNixDirenvIntegration = true;
    nix-direnv.enable = true;
  };
}

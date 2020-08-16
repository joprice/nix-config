{ config, pkgs, pkgsPath, lib, ... }:
let
  #crate2nix = import (builtins.fetchTarball "https://github.com/kolloch/crate2nix/tarball/e07af104b8e41d1cd7e41dc7ac3fdcdf4953efae") { };
  crate2nix = import (builtins.fetchTarball "https://github.com/lopsided98/crate2nix/tarball/d0b41938906c2fcaf86ae0b5b5a5d0d738ba1fff") {};
  async-profiler = pkgs.callPackage ./async-profiler.nix {};
  # git checkout with skim https://github.com/lotabout/skim
  git-cof =
    pkgs.writeShellScriptBin "git-cof" ''
      export PATH=${pkgs.stdenv.lib.makeBinPath [ pkgs.git pkgs.skim ]}:$PATH
      git for-each-ref --format='%(refname:short)' refs/heads | sk | xargs git checkout
    '';
  # Find and delete branches that were squash-merged
  git-delete-squashed =
    pkgs.writeShellScriptBin "git-delete-squashed" (lib.fileContents ./delete-squashed.sh);
  ocaml-lsp = pkgs.callPackage ./ocaml-lsp.nix {};
  # install sbt with scala native at different path?
  #sbt = pkgs.sbt-with-scala-native;#.override { jre = pkgs.jdk11; };
  # TODO: how to override jre globally?
  sbt = pkgs.sbt.override { jre = pkgs.jdk11; };
  scala = pkgs.scala;
  #scala = (pkgs.callPackage "${pkgsPath}/pkgs/development/compilers/scala/2.x.nix" { jre = pkgs.jdk11; }).scala_2_13;
  visualvm = pkgs.visualvm.override { jdk = pkgs.jdk11; };
  mill = pkgs.mill.override { jre = pkgs.jdk11; };
  leiningen = pkgs.leiningen.override { jdk = pkgs.jdk11; };
  # some android manager tooling fails on jdk11
  jdk = pkgs.jdk8;
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
  easy-ps = import
    (
      pkgs.fetchFromGitHub {
        owner = "justinwoo";
        repo = "easy-purescript-nix";
        rev = "860a95cb9e1ebdf574cede2b4fcb0f66eac77242";
        sha256 = "1ly3bm6i1viw6d64gi1zfiwdvjncm3963rj59320cr15na5bzjri";
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
  bazel = pkgs.symlinkJoin {
    name = "bazel";
    paths = [ pkgs.bazelisk ];
    postBuild = "ln $out/bin/bazelisk $out/bin/bazel";
  };
  haskell = with pkgs; haskellPackages.ghcWithPackages (
    pkgs: [
      haskellPackages.pretty-simple
    ]
  );
  z = pkgs.callPackage ./z.nix {};
  scala = pkgs.scala.overrideAttrs (
    oldAttrs: {
      # this is set to an arbitrary number to allow fsc from fsharp to take
      # precendence on the path over scala's fsc
      meta.priority = "10";
    }
  );
in
{
  programs.home-manager.enable = true;
  home.username = "josephprice";
  home.homeDirectory = "/Users/josephprice";
  # TODO: use machines to make this relative? or other way to make dynamic?
  #home.username = "joseph";
  #home.homeDirectory = "/home/joseph";
  home.stateVersion = "21.03";
  # TODO: exclude df
  home.packages = with pkgs; [
    alacritty
    async-profiler
    awscli
    bazel
    bat
    cabal-install
    ccls
    cocoapods
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
    direnv
    fsharp
    dotnet-sdk_3
    (add ocamlformat and note on hound)
    git-cof
    git-delete-squashed
    github-cli
    go
    graphviz
    gron
    haskell
    htop
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
    loc
    maven
    mill
    niv
    nixpkgs-fmt
    nix-index
    nodePackages.node2nix
    nodejs-12_x
    #obelisk
    ocaml
    #ocaml-lsp.ocaml-lsp-server
    #ocaml-lsp.opam2nixResolve
    #ocamlPackages.utop
    pstree
    ocamlPackages.utop
    (add ocamlformat and note on hound)
    ripgrep # rg - faster grep
    rlwrap
    rnix-lsp
    rustup
    rust-analyzer
    sbt
    scala
    stack
    skim
    telnet
    tree
    visualvm
    vscode
    yarn
    z
    zlib
    nodePackages.bower
    libiconv
    xcpretty
    websocat
    #xquartz
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
      #coc-sourcekit
      ale
      coc-metals
      coc-nvim
      coc-json
      ctrlp
      ghcid
      #gitgutter
      psc-ide-vim
      vim-airline
      vim-airline-themes
      vim-polyglot
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
      vi = "nvim";
      vim = "nvim";
      nixgc = "nix-collect-garbage -d";
      nixq = "nix-env -qaP";
      # TODO: this alias works around df only showing the nix volume when used from nix
      df = "/bin/df";
      # prints contents of paths on separate lines
      path = ''echo -e ''${PATH//:/\\n}'';
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
    JAVA_HOME = "${jdk.home}";
    LESS = "-RFX";
    EDITOR = "nvim";
  };
  home.file.".sbt/1.0/plugins/plugins.sbt".source = ./plugins.sbt;
  home.file.".config/nvim/coc-settings.json".source = ./coc-settings.json;
  programs.direnv = {
    enable = true;
    enableNixDirenvIntegration = true;
  };
  programs.emacs = {
    enable = true;
    extraPackages = epkgs: with epkgs; [
      company
      company-nixos-options
      counsel
      reykjavik-theme
      #dracula-theme
      evil
      evil-collection
      evil-magit
      fzf
      magit
      nix-mode
      use-package
      which-key
      proofgeneral_HEAD
    ];
  };
}

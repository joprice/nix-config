{ config, pkgs, pkgsPath, lib, ... }:
let
  #crate2nix = import (builtins.fetchTarball "https://github.com/kolloch/crate2nix/tarball/e07af104b8e41d1cd7e41dc7ac3fdcdf4953efae") { };
  # this version has experimental cross compilation support
  crate2nix = import (builtins.fetchTarball "https://github.com/lopsided98/crate2nix/tarball/d0b41938906c2fcaf86ae0b5b5a5d0d738ba1fff") { };
  async-profiler = pkgs.callPackage ./async-profiler.nix { };
  # git checkout with skim https://github.com/lotabout/skim
  git-cof =
    pkgs.writeShellScriptBin "git-cof" ''
      export PATH=${pkgs.stdenv.lib.makeBinPath [ pkgs.git pkgs.skim ]}:$PATH
      git for-each-ref --format='%(refname:short)' refs/heads | sk | xargs git checkout
    '';
  # Find and delete branches that were squash-merged
  git-delete-squashed =
    pkgs.writeShellScriptBin "git-delete-squashed" (lib.fileContents ./delete-squashed.sh);
  haskell = with pkgs; haskellPackages.ghcWithPackages (pkgs: [
    haskellPackages.pretty-simple
  ]);
  z = pkgs.callPackage ./z.nix { };
  ocaml-lsp = pkgs.callPackage ./ocaml-lsp.nix { };
  # TODO: how to override jre globally?
  sbt = pkgs.sbt.override { jre = pkgs.jdk11; };
  scala = (pkgs.callPackage "${pkgsPath}/pkgs/development/compilers/scala/2.x.nix" { jre = pkgs.jdk11; }).scala_2_13;
  visualvm = pkgs.visualvm.override { jdk = pkgs.jdk11; };
  mill = pkgs.mill.override { jre = pkgs.jdk11; };
  leiningen = pkgs.leiningen.override { jdk = pkgs.jdk11; };
  obelisk = (import (builtins.fetchTarball "https://github.com/obsidiansystems/obelisk/archive/11beb6e8cd2419b2429925b76a98f24035e40985.tar.gz") { }).command;
  cabal-project-vim = pkgs.vimUtils.buildVimPlugin {
    name = "cabal-project-vim";
    src = pkgs.fetchFromGitHub {
      owner = "vmchale";
      repo = "cabal-project-vim";
      rev = "0d41e7e41b1948de84847d9731023407bf2aea04";
      sha256 = "15rn54wspy55v9lw3alhv5h9b7sv6yi6az9gzzskzyim76ka0n4g";
    };
  };
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
    bat
    #crate2nix
    cabal2nix
    cachix
    clang-tools
    clojure
    coreutils
    cue
    dhall-json
    git-cof
    git-delete-squashed
    github-cli
    go
    graphviz
    gron
    haskell
    htop
    jdk11
    joker
    loc
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
    nodePackages.node2nix
    nodejs-12_x
    #obelisk
    ocaml
    #ocaml-lsp.ocaml-lsp-server
    #ocaml-lsp.opam2nixResolve
    ocamlPackages.utop
    pstree
    ripgrep # rg - faster grep
    rnix-lsp
    rust-analyzer
    sbt
    scala
    stack
    skim
    tree
    visualvm
    vscode
    yarn
    z
  ];
  programs.opam = {
    enable = true;
  };
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
      ale
      coc-metals
      coc-nvim
      ctrlp
      ghcid
      gitgutter
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
    JAVA_HOME = "${pkgs.jdk11.home}";
    LESS = "-RFX";
    EDITOR = "nvim";
    # TODO: the current graal package in nixpkgs isn't working. Replace this with something nicer
    GRAAL_NATIVE_IMAGE = "$HOME/Downloads/graalvm-ce-java11-20.2.0/Contents/Home/bin/native-image";
  };
  home.file.".sbt/1.0/plugins/plugins.sbt".source = ./plugins.sbt;
  home.file.".config/nvim/coc-settings.json".source = ./coc-settings.json;
  programs.direnv = {
    enable = true;
    enableNixDirenvIntegration = true;
  };
}

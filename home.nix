{ config, pkgs, pkgsPath, lib, ... }:
let
  #crate2nix = import (builtins.fetchTarball "https://github.com/kolloch/crate2nix/tarball/e07af104b8e41d1cd7e41dc7ac3fdcdf4953efae") { };
  # grammarToPlugin = grammar:
  #   let
  #     name = lib.pipe grammar [
  #       lib.getName
  #
  #       # added in buildGrammar
  #       (lib.removeSuffix "-grammar")
  #
  #       # grammars from tree-sitter.builtGrammars
  #       (lib.removePrefix "tree-sitter-")
  #       (lib.replaceStrings [ "-" ] [ "_" ])
  #     ];
  #   in
  #   pkgs.neovimUtils.toVimPlugin (pkgs.runCommand "vimplugin-treesitter-grammar-${name}"
  #     {
  #       meta = {
  #         platforms = lib.platforms.all;
  #       } // grammar.meta;
  #     }
  #     ''
  #       mkdir -p $out/parser
  #       ln -s ${grammar}/parser $out/parser/${name}.so
  #     '');
  tree-sitter-reason = pkgs.stdenv.mkDerivation {
    name = "tree-sitter-reason";
    #version = "0.0.0";
    buildInputs = [ pkgs.tree-sitter pkgs.nodejs ];
    src = pkgs.fetchFromGitHub {
      owner = "danielo515";
      repo = "tree-sitter-reason";
      rev = "936958c8c3b2d76cbeb4dffcfe5a8f929c958e7a";
      hash = "sha256-pVHo8K6KCUAXwLI9dv2Mk1XxCDs990OwfaAhtPx6iEs=";
    };
    buildPhase = ''
      cp binding.gyp.json binding.gyp
      tree-sitter generate
    '';
    installPhase = ''
      mkdir $out
      cp -R {binding.gyp,Cargo.toml,grammar.js,bindings,src} $out/
      cp -r queries $out/queries
    '';
  };
  nvim-treesitter-reason =
    (pkgs.tree-sitter.buildGrammar
      {
        language = "reason";
        version = "0.0.0";
        src = pkgs.fetchFromGitHub {
          owner = "danielo515";
          repo = "nvim-treesitter-reason";
          rev = "f4b91b8daeed0a0ed2604ea663401bf0e97769c0";
          hash = "sha256-HfY55v0mL9hpMrcCjrTPJIKtkwZpaDWB0LCov61EpmA=";
        };
        meta.homepage = "https://github.com/danielo515/nvim-treesitter-reason";
      }).overrideAttrs (o: {
      configurePhase = ''
        cp -R ${tree-sitter-reason}/{binding.gyp,Cargo.toml,grammar.js,bindings,src} tree-sitter-reason/src/
        cp ${tree-sitter-reason}/queries/* queries/reason/
      '' + o.configurePhase;
      buildPhase = ''
        cd tree-sitter-reason
      '' + o.buildPhase;
      installPhase =
        o.installPhase + ''
          cd ../
          cp -r queries $out
        '';
    });
  crate2nix = import (builtins.fetchTarball "https://github.com/lopsided98/crate2nix/tarball/d0b41938906c2fcaf86ae0b5b5a5d0d738ba1fff") { };
  async-profiler = pkgs.callPackage ./async-profiler.nix { };
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
  nix-restart =
    pkgs.writeShellScriptBin "nix-restart" ''
      sudo launchctl stop org.nixos.nix-daemon
      sudo launchctl start org.nixos.nix-daemon
    '';
  # Find and delete branches that were squash-merged
  git-delete-squashed =
    pkgs.writeShellScriptBin "git-delete-squashed" (lib.fileContents ./delete-squashed.sh);
  haskell = with pkgs; haskellPackages.ghcWithPackages (
    pkgs: [
      haskellPackages.pretty-simple
    ]
  );
  z = pkgs.callPackage ./z.nix { };
  ocamlPackages = pkgs.ocaml-ng.ocamlPackages_4_12;
  ocaml-lsp = pkgs.callPackage ./ocaml-lsp.nix {
    inherit ocamlPackages;
  };
  # install sbt with scala native at different path?
  #sbt = pkgs.sbt-with-scala-native;#.override { jre = pkgs.jdk11; };
  # TODO: how to override jre globally?
  sbt = pkgs.sbt.override { jre = pkgs.jdk11; };
  #scala = pkgs.scala3;
  scala = (pkgs.callPackage "${pkgsPath}/pkgs/development/compilers/scala/2.x.nix" {
    jre = pkgs.jdk11;
    majorVersion = "2.13";
  });
  visualvm = pkgs.visualvm.override { jdk = pkgs.jdk11; };
  mill = pkgs.mill.override { jre = pkgs.jdk11; };
  leiningen = pkgs.leiningen.override { jdk = pkgs.jdk11; };
  # NOTE some android manager tooling fails on jdk11, so this needs to be jdk8 for android tasks
  jdk = pkgs.jdk11;
  #obelisk = (import (builtins.fetchTarball "https://github.com/obsidiansystems/obelisk/archive/11beb6e8cd2419b2429925b76a98f24035e40985.tar.gz") { }).command;
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
        rev = "62364658d2979ee03728b099cf25648efe232244";
        sha256 = "sha256:0fs6bscyzfqgm42knhz05bgslknmjlj8yjh1n052g6i652llnr1l";
        #update once new package set is out
        #rev = "7802db65618c2ead3a55121355816b4c41d276d9";
        #sha256 = "sha256:0n99hxxcp9yc8yvx7bx4ac6askinfark7dnps3hzz5v9skrvq15q";
      }
    )
    {
      inherit pkgs;
    };
  vim-jack-syntax = pkgs.vimUtils.buildVimPluginFrom2Nix {
    name = "vim-jack-syntax";
    src = pkgs.fetchFromGitHub {
      owner = "zirrostig";
      repo = "vim-jack-syntax";
      rev = "d1f19733ff5594cf5d6fb498fc599f02326860a6";
      sha256 = "sha256-GY6wJuTjTHvMTs/JulTv90bfveH6yhP2wH9ha9q4BYU=";
    };
  };
  coc-sourcekit = pkgs.vimUtils.buildVimPluginFrom2Nix {
    name = "coc-sourcekit";
    src = pkgs.fetchFromGitHub {
      owner = "klaaspieter";
      repo = "coc-sourcekit";
      rev = "f83a2025c543d11d5a69b62fcbbfd6d47fec5960";
      sha256 = "sha256-1rPCxLl+IxZvMeByxYYLHqH7nnIFlE+Tpmmk9ZUQL+k=";
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
      owner = "keith";
      repo = "swift.vim";
      rev = "3278cf3b0522e6f08eaf11275fedce619beffe9a";
      sha256 = "sha256-yAr9yCRZCFDocTKaAlaOoam3KmFLAtljg/2/yWMiEUI=";
    };
  };
  # vim-swift-format = pkgs.vimUtils.buildVimPlugin {
  #   name = "vim-swift-format";
  #   src = pkgs.fetchFromGitHub {
  #     owner = "tokorom";
  #     repo = "vim-swift-format";
  #     rev = "2984712722b3ba16d06c2970e861196039b94dbe";
  #     sha256 = "0v90qx40nk2zkxf8n0qm776ny81i255z4ns35n59kxvixmj73042";
  #   };
  # };
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
  home.stateVersion = "22.11";
  # TODO: exclude df
  home.packages = with pkgs; [
    circleci-cli
    #bitcoin
    #alacritty
    #async-profiler
    autoconf
    automake
    awscli
    #bazel
    bat
    #cabal-install
    # TODO: binary doesn't seem to install 
    #chez
    #ccls
    # not working https://github.com/NixOS/nixpkgs/issues/132049
    #cocoapods
    #crate2nix
    # this causes ghc to hang on compiling a spec for interpolate
    #cabal2nix
    cachix
    clang-tools
    #clojure
    #cmake
    coreutils
    #cue
    curl
    gitAndTools.delta
    #dhall
    #dhall-json
    #easy-ps.purs
    #easy-ps.psc-package
    #easy-ps.spago
    #easy-ps.pscid
    #easy-ps.purty
    #easy-ps.purescript-language-server
    #flow
    git-cof
    git-delete-squashed
    github-cli
    #gnupg
    go
    #gradle
    #graphviz
    gron
    #haskell
    htop
    hub
    #idea
    istioctl
    #jdk
    joker
    kcat
    loc
    nim
    jq
    kubectl
    kubectx
    # TODO: restrict to non-darwin?
    # unixtools.netstat
    #leiningen
    #libbitcoin-explorer
    loc
    #maven
    #mill
    #niv
    nixpkgs-fmt
    icu
    nix-index
    node2nix
    #nodePackages.esy
    #nushell
    nodejs
    #obelisk
    #ocaml
    #ocaml-lsp.ocaml-lsp-server
    #ocaml-lsp.opam2nixResolve
    #(octave.withPackages (ps: with ps; [ symbolic optim ]))
    #ocamlPackages.utop
    pstree
    chafa
    ripgrep # rg - faster grep
    fd
    rlwrap
    rmlint
    rnix-lsp
    rustup
    zld
    #rust-analyzer
    sbt
    scala
    #stack
    skim
    inetutils
    tree
    #visualvm
    #vscode
    yarn
    z
    zlib
    #nodePackages.bower
    libiconv
    #xcpretty
    #websocat
    watchman
    #xquartz
    fswatch
    upx
    wrk
    #gnuplot
    #micronaut
    #graalvm11-ce
    ioping
    openssl.out
    moreutils
    openssl.dev
    pkg-config
    hound
    #qemu
    #wasmer
    nim
    tokei
    procs
    figlet
    #plantuml
    #postgresql
    pgcli
    pv
    #erlang
    pcre
    #SDL2
    #SDL2.dev
    #imagemagick
    #protobuf
    systemfd
    trunk
    ffmpeg
    ffmpeg.dev
    pcre
    gource
    nerdfonts
    #coursier
    #metals
    # TODO: temporarily using this instead of programs.neovim since extraConfig is broken in current 
    # nixpkgs and 21.11 and unstable channels are broken for darwin due to libcxx issues
    (neovim.override
      {
        configure = {
          customRC = ''luafile ${./vimrc.lua}'';
          packages.myPlugins = with pkgs.vimPlugins; {
            start = [
              zig-vim
              # these don't work for some reason
              #vim-swift
              #vim-swift-format
              #vim-markdown-preview
              #coc-sourcekit
              vim-jack-syntax
              #ale
              #coc-kotlin
              # required by nvim-metals
              nvim-dap
              # required by nvim-metals
              plenary-nvim
              #nvim-metals
              coc-nvim
              catppuccin-nvim
              # this server crashes on start
              coc-java
              coc-jedi
              comment-nvim
              coc-json
              coc-prettier
              coc-tsserver
              coc-rust-analyzer
              #ctrlp
              #ghcid
              #gitgutter
              psc-ide-vim
              vim-airline
              vim-airline-themes
              vim-polyglot
              vim-capnp
              vim-colorschemes
              #cabal-project-vim
              zenburn
              # coment out with double ctrl+/ or gcc
              tcomment_vim
              nightfox-nvim
              tokyonight-nvim
              onedark-nvim
              nvim-treesitter
              trouble-nvim
              (nvim-treesitter.withPlugins (p: with p; [
                json
                lua
                ocaml
                ocaml_interface
                markdown
                sql
                vim
                #nvim-treesitter-reason
              ]))
              #nvim-treesitter-reason
              todo-comments-nvim
              nvim-web-devicons
              telescope-nvim
              telescope-coc-nvim
              telescope-fzy-native-nvim
              telescope-frecency-nvim
              telescope-media-files-nvim
              telescope-z-nvim
              which-key-nvim
            ];
            opt = [ ];
          };
          # ...
        };
      })
  ];
  #programs.opam = {
  #  enable = true;
  #};
  nixpkgs.config.allowUnfree = true;
  #  programs.neovim = with pkgs.vimPlugins; {
  #    enable = true;
  #    viAlias = true;
  #    vimAlias = true;
  #    vimdiffAlias = true;
  #    # needed by coc-nvim
  #    withNodeJs = true;
  #    #extraConfig = builtins.toString ./vimrc;
  #    extraConfig = builtins.readFile ./vimrc;
  #    #extraConfig = lib.fileContents ./vimrc;
  #    plugins = [
  #      zig-vim
  #      # these don't work for some reason
  #      vim-swift
  #      vim-swift-format
  #      #vim-markdown-preview
  #      #coc-sourcekit
  #      ale
  #      #coc-kotlin
  #      coc-metals
  #      coc-nvim
  #      # this server crashes on start
  #      coc-java
  #      coc-jedi
  #      coc-json
  #      coc-prettier
  #      coc-tsserver
  #      coc-rust-analyzer
  #      ctrlp
  #      #ghcid
  #      #gitgutter
  #      psc-ide-vim
  #      vim-airline
  #      vim-airline-themes
  #      vim-polyglot
  #      vim-capnp
  #      vim-colorschemes
  #      cabal-project-vim
  #      zenburn
  #      # coment out with double ctrl+/ or gcc
  #      tcomment_vim
  #    ];
  #  };
  programs.git = {
    enable = true;
    lfs.enable = true;
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
      nix-search = ''nix --extra-experimental-features "nix-command flakes" search nixpkgs'';
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
        #"git"
        "gitfast"
        "github"
        "web-search"
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
  #nix = {
  #  distributedBuilds = true;
  #  buildMachines = [{
  #    hostName = "builder";
  #    system = "aarch64-linux";
  #    maxJobs = 10;
  #    speedFactor = 2;
  #    supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
  #    mandatoryFeatures = [ ];
  #  }];
  #};
}

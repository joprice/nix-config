{ config, pkgs, pkgsPath, lib, ... }:
let
  #crate2nix = import (builtins.fetchTarball "https://github.com/kolloch/crate2nix/tarball/e07af104b8e41d1cd7e41dc7ac3fdcdf4953efae") { };
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
  treesitter-roc-src = pkgs.fetchFromGitHub {
    owner = "nat-418";
    repo = "tree-sitter-roc";
    rev = "a639cb367b0ffe95cd7d94ad5b4a26da0337180f";
    hash = "sha256-Zdm0lPH3nnCJso+7Qyc92/xl0yLd4Ee+QZa5ix0GwJY=";
  };
  treesitter-roc = pkgs.tree-sitter.buildGrammar {
    language = "roc";
    version = "0.0.0+rev=7df2c08";
    src = treesitter-roc-src;
    meta.homepage = "https://github.com/nat-418/tree-sitter-roc";
  };
  roc-wrapped-parser = pkgs.neovimUtils.grammarToPlugin treesitter-roc;
  nvim-treesitter-roc =
    let
      scripts = pkgs.runCommand "neovim-treesitter-roc-scripts" { } ''
        mkdir -p $out/after
        mkdir -p $out/plugin
        cp ${treesitter-roc-src}/neovim/roc.lua $out/plugin
        mkdir -p $out/after/queries/roc
        cp -r ${treesitter-roc-src}/neovim/queries/* $out/after/queries/roc/
      '';
    in
    pkgs.symlinkJoin {
      name = "neovim-treesitter-roc";
      paths = [
        roc-wrapped-parser
        scripts
      ];
    };
  vim-dot-http = pkgs.vimUtils.buildVimPlugin {
    pname = "vim-dot-http";
    version = "0.0.1";
    src = pkgs.fetchFromGitHub {
      owner = "bayne";
      repo = "vim-dot-http";
      rev = "c480089b6fbfd9d4e5998348002f46da4f3a6fc1";
      sha256 = "sha256-3ji2WFfuJII4Daq4WTx2W/y5tSuP8ak/r5K0VQdpyJ0=";
    };
  };
  vim-mdx-js = pkgs.vimUtils.buildVimPlugin {
    pname = "vim-mdx-js";
    version = "0.0.1";
    src = pkgs.fetchFromGitHub {
      owner = "nake89";
      repo = "vim-mdx-js";
      rev = "e578775a0be4de62091b1e34719bc788e222489d";
      sha256 = "sha256-ikGAniQ6QfZ3AjynKoxij63j+JcafazUOwmCdiGpy8c=";
    };
  };
  magma-nvim = pkgs.vimUtils.buildVimPlugin {
    pname = "magma-nvim-goose";
    version = "2023-03-13";
    src = pkgs.fetchFromGitHub {
      owner = "dccsillag";
      repo = "magma-nvim";
      rev = "ff3deba8a879806a51c005e50782130246143d06";
      sha256 = "sha256-IrMR57gk9iCk73esHO24KZeep9VrlkV5sOC4PzGexyo=";
    };
    passthru.python3Dependencies = ps:
      with ps; [
        pynvim
        jupyter-client
        ueberzug
        pillow
        cairosvg
        plotly
        ipykernel
        pyperclip
        pnglatex
      ];
    meta.homepage = "https://github.com/WhiteBlackGoose/magma-nvim-goose/";
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
  # crate2nix = import (builtins.fetchTarball "https://github.com/lopsided98/crate2nix/tarball/d0b41938906c2fcaf86ae0b5b5a5d0d738ba1fff") { };
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
  scala = pkgs.callPackage "${pkgsPath}/pkgs/development/compilers/scala/2.x.nix" {
    jre = pkgs.jdk11;
    majorVersion = "2.13";
  };
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
  vim-jack-syntax = pkgs.vimUtils.buildVimPlugin {
    name = "vim-jack-syntax";
    src = pkgs.fetchFromGitHub {
      owner = "zirrostig";
      repo = "vim-jack-syntax";
      rev = "d1f19733ff5594cf5d6fb498fc599f02326860a6";
      sha256 = "sha256-GY6wJuTjTHvMTs/JulTv90bfveH6yhP2wH9ha9q4BYU=";
    };
  };
  coc-sourcekit = pkgs.vimUtils.buildVimPlugin {
    name = "coc-sourcekit";
    src = pkgs.fetchFromGitHub {
      owner = "klaaspieter";
      repo = "coc-sourcekit";
      rev = "f83a2025c543d11d5a69b62fcbbfd6d47fec5960";
      sha256 = "sha256-1rPCxLl+IxZvMeByxYYLHqH7nnIFlE+Tpmmk9ZUQL+k=";
    };
  };
  coc-jedi = pkgs.vimUtils.buildVimPlugin {
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
  #vim-markdown-preview = pkgs.vimUtils.buildVimPlugin {
  #  name = "vim-markdown-preview";
  #  src = pkgs.fetchFromGitHub {
  #    owner = "iamcco";
  #    repo = "markdown-preview.nvim";
  #    rev = "e5bfe9b89dc9c2fbd24ed0f0596c85fd0568b143";
  #    sha256 = "0bfkcfjqg2jqm4ss16ks1mfnlnpyg1l4l18g7pagw1dfka14y8fg";
  #  };
  #  buildPhase = ''
  #    touch .yarnrc
  #    ${pkgs.yarn}/bin/yarn --no-default-rc --disable-pnp --pure-lockfile install
  #  '';
  #};
  bazel = pkgs.symlinkJoin {
    name = "bazel";
    paths = [ pkgs.bazelisk ];
    postBuild = "ln $out/bin/bazelisk $out/bin/bazel";
  };
  dotnetSdk = (with pkgs.dotnetCorePackages; combinePackages [
    sdk_6_0
    sdk_7_0
    sdk_8_0
  ]);
in
{
  # For options, see https://mynixos.com/home-manager/options/programs
  programs.home-manager.enable = true;
  programs.chromium.enable = true;
  #home.username = "josephprice";
  #home.homeDirectory = "/Users/josephp";
  # TODO: use machines to make this relative? or other way to make dynamic?
  home.username = "josephp";
  home.homeDirectory = "/home/josephp";
  # nixpkgs.overlays = [
  #   (import (builtins.fetchTarball {
  #     url =
  #       "https://github.com/nix-community/neovim-nightly-overlay/archive/119bbc295f56b531cb87502f5d2fff13dcc35a35.tar.gz";
  #   }))
  # ];
  # nixpkgs.overlays = [
  #   (final: prev:
  #     # let
  #     #   pkgs = import
  #     #     (builtins.fetchTarball {
  #     #       # 0.9.5
  #     #       url = "https://github.com/NixOS/nixpkgs/archive/cbb7b09bad82e5a7b8a1dce70948652da05276fc.tar.gz";
  #     #     })
  #     #     { };
  #     # in
  #     # in
  #     # {
  #     #   inherit (pkgs) neovim-unwrapped;
  #     # })
  #     let msgpack-c = prev.callPackage ./msgpack-c.nix { }; in
  #     {
  #       neovim-unwrapped = with pkgs;
  #         with darwin.apple_sdk.frameworks;
  #         callPackage ./neovim.nix {
  #           inherit msgpack-c;
  #           inherit fetchurl;
  #           inherit CoreServices;
  #         };
  #     }
  #   )
  # ];
  home.stateVersion = "23.11";
  # TODO: exclude df
  home.packages = with pkgs; [
    android-studio
    #flutter
    bun
    flyctl
    unzip
    inkscape
    gimp
    icu
    icu.dev
    bazelisk
    buildifier
    mosh
    #ollama
    efm-langserver
    #swift-format
    #starlark-rust
    #zig
    tailspin
    nil
    statix
    nodePackages.vscode-langservers-extracted
    nodePackages.typescript-language-server
    nodePackages."@tailwindcss/language-server"
    # this pulls in cuda
    #nvtop
    lua-language-server
    circleci-cli
    # TODO: wrap in linux check
    #cudatoolkit
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
    cmake
    coreutils
    #cue
    #curl
    #screen
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
    gcc
    git-cof
    git-delete-squashed
    github-cli
    #gnupg
    go
    #gradle
    graphviz
    gron
    htop
    hub
    #idea
    istioctl
    #jdk
    joker
    kcat
    loc
    sccache
    #nim
    jq
    kubectl
    setserial
    kubectx
    tio
    # TODO: restrict to non-darwin?
    # unixtools.netstat
    #leiningen
    #libbitcoin-explorer
    loc
    #maven
    #mill
    #niv
    tdesktop
    maven
    dotnetSdk
    #dotnetCorePackages.sdk_7_0
    #dotnetCorePackages.runtime_8_0
    #dotnet-runtime
    k6
    oha
    mill
    niv
    nixpkgs-fmt
    icu
    nix-index
    node2nix
    #nodePackages.esy
    #nushell
    #nodePackages.node2nix
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
    #rnix-lsp
    rustup
    #sbt
    #scala
    #stack
    #zld
    #rustup
    #rust-analyzer
    sbt
    stack
    skim
    file
    dig
    gnumake
    xclip
    nmap
    rpi-imager
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
    slack
    #xquartz
    fswatch
    #upx
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
    #kitty
    #qemu
    #wasmer
    tokei
    #procs
    #figlet
    #plantuml
    postgresql
    #postgresql
    dtc
    pgcli
    pv
    #erlang
    pcre
    #SDL2
    #SDL2.dev
    imagemagick
    #protobuf
    systemfd
    trunk
    ffmpeg
    ffmpeg.dev
    pcre
    gource
    #nerdfonts
    (nerdfonts.override {
      fonts = [ "FiraCode" ];
    })
    gnused
    #coursier
    metals
    # TODO: temporarily using this instead of programs.neovim since extraConfig is broken in current
    #imagemagick
    pciutils
    #grpc_cli
    #protobuf
    systemfd
    trunk
    dune_3
    #docker
    # TODO: temporarily using this instead of programs.neovim since extraConfig is broken in current
    # nixpkgs and 21.11 and unstable channels are broken for darwin due to libcxx issues
    #luarocks
    # (neovim.override
    #   {
    #     configure = {
    #       # extraLuaPackages = p: [
    #       #   p.luarocks
    #       #   p.rocks-nvim
    #       #   p.nvim-nio
    #       #   p.lua-curl
    #       #   p.xml2lua
    #       #   p.mimetypes
    #       #   p.x
    #       # ];
    #       #customRC = ''luafile ${./vimrc.lua}'';
    #       customRC = ''luafile ~/.config/home-manager/init.lua'';
    #       packages.myPlugins = with pkgs.vimPlugins;
    #         let
    #           treesitter = (nvim-treesitter.withPlugins (p: with p; [
    #             graphql
    #             http
    #             json
    #             lua
    #             markdown
    #             ocaml
    #             ocaml_interface
    #             sql
    #             vim
    #             xml
    #             #nvim-treesitter-reason
    #           ]));
    #           # rest-nvim = callPackage
    #           #   ({ buildLuarocksPackage, fetchurl, fetchzip, lua, luaOlder }:
    #           #     buildLuarocksPackage {
    #           #       pname = "rest.nvim";
    #           #       version = "0.2-1";
    #           #       knownRockspec = (fetchurl {
    #           #         url = "mirror://luarocks/rest.nvim-0.2-1.rockspec";
    #           #         sha256 = "1yq8gx585c10j8kybp20swyv9q0i3lm5k0rrv4bgsbwz3ychn0k1";
    #           #       }).outPath;
    #           #       src = fetchzip {
    #           #         url = "https://github.com/rest-nvim/rest.nvim/archive/0.2.zip";
    #           #         sha256 = "0ycjrrl37z465p71bdkas3q2ky1jmgr2cjnirnskdc6wz14wl09g";
    #           #       };
    #           #
    #           #       disabled = (luaOlder "5.1");
    #           #       propagatedBuildInputs = [ lua ];
    #           #
    #           #       meta = {
    #           #         homepage = "https://github.com/rest-nvim/rest.nvim";
    #           #         description = "A fast Neovim http client written in Lua";
    #           #         maintainers = with lib.maintainers; [ teto ];
    #           #         license.fullName = "MIT";
    #           #       };
    #           #     })
    #           #   { };
    #         in
    #         {
    #           start = [
    #             plenary-nvim
    #             #rocks-nvim
    #             #nvimLua.pkgs.luarocks
    #             #rocks-nvim
    #             treesitter
    #             #telescope-coc-nvim
    #             #coc-nvim
    #             #coc-java
    #             #coc-jedi
    #             #coc-json
    #             #coc-prettier
    #             #coc-tsserver
    #             #coc-rust-analyzer
    #             #coc-sourcekit
    #             #coc-kotlin
    #             fidget-nvim
    #             neodev-nvim
    #             auto-session
    #             zig-vim
    #             # these don't work for some reason
    #             #vim-swift
    #             #vim-swift-format
    #             vim-jack-syntax
    #             #ale
    #             # required by nvim-metals
    #             nvim-dap
    #             # required by nvim-metals
    #             plenary-nvim
    #             #nvim-metals
    #             catppuccin-nvim
    #             # this server crashes on start
    #             comment-nvim
    #             #ctrlp
    #             #ghcid
    #             #gitgutter
    #             psc-ide-vim
    #             vim-airline
    #             vim-airline-themes
    #             #vim-capnp
    #             vim-colorschemes
    #             #cabal-project-vim
    #             zenburn
    #             # coment out with double ctrl+/ or gcc
    #             tcomment_vim
    #             nightfox-nvim
    #             tokyonight-nvim
    #             onedark-nvim
    #             nvim-treesitter
    #             trouble-nvim
    #             #nvim-treesitter-reason
    #             barbar-nvim
    #             cmp-nvim-lsp
    #             cmp-nvim-lsp-signature-help
    #             cmp_luasnip
    #             friendly-snippets
    #             gitsigns-nvim
    #             lsp-format-nvim
    #             luasnip
    #             markdown-preview-nvim
    #             nil
    #             # fsharp support
    #             #Ionide-vim
    #             nlsp-settings-nvim
    #             nvim-cmp
    #             nvim-lightbulb
    #             nvim-lspconfig
    #             nvim-web-devicons
    #             telescope-file-browser-nvim
    #             telescope-frecency-nvim
    #             telescope-fzy-native-nvim
    #             telescope-media-files-nvim
    #             telescope-nvim
    #             telescope-z-nvim
    #             todo-comments-nvim
    #             vim-prettier
    #             # (rest-nvim.overrideAttrs (o: {
    #             #   src = fetchFromGitHub {
    #             #     owner = "rest-nvim";
    #             #     repo = "rest.nvim";
    #             #     rev = "a1221086cfdeb58de393f4bbae11063c6c8c075c";
    #             #     sha256 = "sha256-kiY2CqKLa0wbqDVkFIXsTV9/qW5ZkFShmANK86Vg8ik=";
    #             #   };
    #             #   dependencies = o.dependencies ++ [
    #             #     nvim-nio
    #             #   ];
    #             #   # dependencies = with self; [
    #             #   #   plenary-nvim
    #             #   #   treesitter
    #             #   #   (nvim-treesitter.withPlugins (p: [ p.http p.json ]))
    #             #   # ];
    #             # }))
    #             vim-slime
    #             magma-nvim
    #             which-key-nvim
    #             (nvim-lint.overrideAttrs {
    #               src = pkgs.fetchFromGitHub {
    #                 owner = "mfussenegger";
    #                 repo = "nvim-lint";
    #                 rev = "4f2d968a827d86bb40b7b1fad28c11f7b764fef3";
    #                 sha256 = "sha256-S2m6MpYIirEX5R05xNRhtaKnmerEtzJP7P9aCL+nwEQ=";
    #               };
    #             })
    #             formatter-nvim
    #             #statix
    #             #sniprun
    #           ];
    #           opt = [
    #             vim-polyglot
    #           ];
    #         };
    #       # ...
    #     };
    #   })
    discord
    luarocks
    #lua
    # (
    #   lua.withPackages (p: with p;
    #   [
    #     luarocks
    #     rocks-nvim
    #     nvim-nio
    #     lua-curl
    #     xml2lua
    #     mimetypes
    #   ]))
    # tidy
  ];
  # programs.opam = {
  #   enable = true;
  # };
  nixpkgs.config.allowUnfree = true;
  programs.neovim = with pkgs.vimPlugins; {
    extraLuaPackages = p: [
      p.luarocks
      p.rocks-nvim
      p.nvim-nio
      p.lua-curl
      p.xml2lua
      p.mimetypes
    ];
    extraConfig = ''luafile ~/.config/home-manager/init.lua'';
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    plugins = with pkgs.vimPlugins;
      let
        treesitter = (nvim-treesitter.withPlugins (p: with p; [
          graphql
          http
          json
          lua
          markdown
          ocaml
          ocaml_interface
          sql
          vim
          xml
          typescript
          tsx
          astro
          css
          #(pkgs.neovimUtils.grammarToPlugin roc)
          roc-wrapped-parser
          #nvim-treesitter-reason
        ]));
        # rest-nvim = callPackage
        #   ({ buildLuarocksPackage, fetchurl, fetchzip, lua, luaOlder }:
        #     buildLuarocksPackage {
        #       pname = "rest.nvim";
        #       version = "0.2-1";
        #       knownRockspec = (fetchurl {
        #         url = "mirror://luarocks/rest.nvim-0.2-1.rockspec";
        #         sha256 = "1yq8gx585c10j8kybp20swyv9q0i3lm5k0rrv4bgsbwz3ychn0k1";
        #       }).outPath;
        #       src = fetchzip {
        #         url = "https://github.com/rest-nvim/rest.nvim/archive/0.2.zip";
        #         sha256 = "0ycjrrl37z465p71bdkas3q2ky1jmgr2cjnirnskdc6wz14wl09g";
        #       };
        #
        #       disabled = (luaOlder "5.1");
        #       propagatedBuildInputs = [ lua ];
        #
        #       meta = {
        #         homepage = "https://github.com/rest-nvim/rest.nvim";
        #         description = "A fast Neovim http client written in Lua";
        #         maintainers = with lib.maintainers; [ teto ];
        #         license.fullName = "MIT";
        #       };
        #     })
        #   { };
      in
      [
        nvim-treesitter-roc
        plenary-nvim
        #rocks-nvim
        #nvimLua.pkgs.luarocks
        #rocks-nvim
        treesitter
        #telescope-coc-nvim
        #coc-nvim
        #coc-java
        #coc-jedi
        #coc-json
        #coc-prettier
        #coc-tsserver
        #coc-rust-analyzer
        #coc-sourcekit
        #coc-kotlin
        fidget-nvim
        neodev-nvim
        auto-session
        zig-vim
        # these don't work for some reason
        #vim-swift
        #vim-swift-format
        vim-jack-syntax
        vim-mdx-js
        #ale
        # required by nvim-metals
        nvim-dap
        # required by nvim-metals
        plenary-nvim
        #nvim-metals
        catppuccin-nvim
        # this server crashes on start
        comment-nvim
        #ctrlp
        #ghcid
        #gitgutter
        psc-ide-vim
        vim-airline
        vim-airline-themes
        #vim-capnp
        vim-colorschemes
        #cabal-project-vim
        zenburn
        # coment out with double ctrl+/ or gcc
        tcomment_vim
        nightfox-nvim
        tokyonight-nvim
        onedark-nvim
        #nvim-treesitter
        trouble-nvim
        #nvim-treesitter-reason
        barbar-nvim
        cmp-nvim-lsp
        cmp-nvim-lsp-signature-help
        cmp_luasnip
        friendly-snippets
        gitsigns-nvim
        lsp-format-nvim
        luasnip
        markdown-preview-nvim
        #nil
        # fsharp support
        #Ionide-vim
        nlsp-settings-nvim
        nvim-cmp
        nvim-lightbulb
        nvim-lspconfig
        neoconf-nvim
        nvim-web-devicons
        telescope-file-browser-nvim
        telescope-frecency-nvim
        telescope-fzy-native-nvim
        telescope-media-files-nvim
        telescope-nvim
        telescope-z-nvim
        todo-comments-nvim
        vim-prettier
        vim-flutter
        # (rest-nvim.overrideAttrs (o: {
        #   src = pkgs.fetchFromGitHub {
        #     owner = "rest-nvim";
        #     repo = "rest.nvim";
        #     rev = "a1221086cfdeb58de393f4bbae11063c6c8c075c";
        #     sha256 = "sha256-kiY2CqKLa0wbqDVkFIXsTV9/qW5ZkFShmANK86Vg8ik=";
        #   };
        #   dependencies = [
        #     plenary-nvim
        #     #nvim-treesitter
        #   ];
        #   #   # dependencies = with self; [
        #   #   #   plenary-nvim
        #   #   #   treesitter
        #   #   #   (nvim-treesitter.withPlugins (p: [ p.http p.json ]))
        #   #   # ];
        # }))
        vim-slime
        magma-nvim
        which-key-nvim
        (nvim-lint.overrideAttrs {
          src = pkgs.fetchFromGitHub {
            owner = "mfussenegger";
            repo = "nvim-lint";
            rev = "4f2d968a827d86bb40b7b1fad28c11f7b764fef3";
            sha256 = "sha256-S2m6MpYIirEX5R05xNRhtaKnmerEtzJP7P9aCL+nwEQ=";
          };
        })
        formatter-nvim
        #statix
        #sniprun
      ];
    #opt = [
    #  vim-polyglot
    #];
    #    # needed by coc-nvim
    withNodeJs = true;
    #    #extraConfig = builtins.toString ./vimrc;
    #    extraConfig = builtins.readFile ./vimrc;
    #    #extraConfig = lib.fileContents ./vimrc;
    #   plugins = [
    #     #      zig-vim
    #     #      # these don't work for some reason
    #     #      vim-swift
    #     #      vim-swift-format
    #     #      #vim-markdown-preview
    #     #      #coc-sourcekit
    #     #      ale
    #     #      #coc-kotlin
    #     #      coc-metals
    #     #      coc-nvim
    #     #      # this server crashes on start
    #     #      coc-java
    #     #      coc-jedi
    #     #      coc-json
    #     #      coc-prettier
    #     #      coc-tsserver
    #     #      coc-rust-analyzer
    #     #      ctrlp
    #     #      #ghcid
    #     #      #gitgutter
    #     #      psc-ide-vim
    #     #      vim-airline
    #     #      vim-airline-themes
    #     #      vim-polyglot
    #     #      vim-capnp
    #     #      vim-colorschemes
    #     #      cabal-project-vim
    #     #      zenburn
    #     #      # coment out with double ctrl+/ or gcc
    #     #      tcomment_vim
    #   ];
  };
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
      ".ipynb_checkpoints/"
    ];
  };
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    history.extended = true;
    shellAliases = {
      vimdiff = "nvim -d";
      cat = "bat";
      vi = "nvim";
      vim = "nvim";
      nixgc = "nix-collect-garbage -d";
      nixq = "nix-env -qaP";
      nix-search = ''nix --extra-experimental-features "nix-command flakes" search nixpkgs'';
      # TODO: this alias works around df only showing the nix volume when used from nix
      #df = "/bin/df";
      # prints contents of paths on separate lines
      path = ''echo -e ''${PATH//:/\\n}'';
      # -I ignores binary files
      grep = "grep --color -I";
      ips = "ifconfig | awk '\$1 == \"inet\" {print \$2}'";
      hup = "home-manager switch && exec $SHELL";
      vim-debug = "vim -V9vim.log main.cpp";
      ls = "ls --color=auto";
      gh-pr = "gh pr create --fill";
      pbcopy = "xclip -selection clipboard";
      pbpaste = "xclip -selection clipboard -o";
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
    initExtra =
      let
        NIX_LD_LIBRARY_PATH = with pkgs; lib.makeLibraryPath [
          stdenv.cc.cc
          zlib
        ];
      in
      #export NIX_LD=${pkgs.lib.fileContents "${pkgs.stdenv.cc}/nix-support/dynamic-linker"}
      ''
        set -o vi
        bindkey "^?" backward-delete-char
        . ${z}/bin/z.sh
        unsetopt AUTO_CD
        export PATH=$HOME/.local/bin:$PATH
        nix-build-nodirenv() {
          pushd /; popd;
        }
        #export NIX_LD_LIBRARY_PATH=${NIX_LD_LIBRARY_PATH}
        #export DOTNET_ROOT=${pkgs.dotnetCorePackages.sdk_8_0}
        export DOTNET_ROOT=${dotnetSdk}
        # this loads vars that are meant to be dynamic, e.g. github tokens
        source ~/.zinstance_vars
        export RUSTC_WRAPPER="${pkgs.sccache}/bin/sccache"
      '';
  };
  home.sessionVariables = rec {
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
    # this allow rust programs to find openssl
    OPENSSL_DIR = OPENSSL_PREFIX;
    DOTNET_CLI_TELEMETRY_OPTOUT = 1;
    DOTNET_SYSTEM_GLOBALIZATION_INVARIANT = 1;
  };
  home.file.".sbt/1.0/plugins/plugins.sbt".source = ./plugins.sbt;
  home.file.".config/nvim/coc-settings.json".source = ./coc-settings.json;
  home.file.".postgresql/root.crt".source = ./root.crt;
  # (pkgs.writeTextDir "/var/empty/.postgresql/root.crt" (builtins.readFile ./nix/root.crt))
  programs.direnv = {
    enable = true;
    #enableNixDirenvIntegration = true;
    nix-direnv.enable = true;
  };
  programs.vscode = {
    enable = true;
    package = pkgs.vscode.fhs;
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

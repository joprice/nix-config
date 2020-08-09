{ config, pkgs, lib, ... }:
let
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
in
{
  programs.home-manager.enable = true;
  home.username = "josephprice";
  home.homeDirectory = "/Users/josephprice";
  home.stateVersion = "20.09";
  home.packages = with pkgs; [
    async-profiler
    bat
    clang-tools
    dhall-json
    direnv
    git-cof
    git-delete-squashed
    haskell
    htop
    jdk11
    maven
    kubectl
    kubectx
    nixpkgs-fmt
    ocaml
    ripgrep # rg - faster grep
    rustup
    # TODO: how to override jre globally?
    (sbt.override { jre = jdk11; })
    (scala.override { jre = pkgs.jdk11; })
    skim
    vscode
    yarn
    z
  ];
  nixpkgs.config.allowUnfree = true;
  home.sessionVariables = {
    JAVA_HOME = "${pkgs.jdk11.home}";
    LESS = "-RFX";
    EDITOR = "vim";
  };
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
      vim-airline
      vim-airline-themes
      vim-polyglot
      zenburn
    ];
  };
  programs.git = {
    enable = true;
    userName = "Joseph Price";
    userEmail = "pricejosephd@gmail.com";
    aliases = {
      s = "status";
      co = "checkout";
      recent = "for-each-ref --sort=committerdate refs/heads/ --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(color:red)%(objectname:short)%(color:reset) - %(contents:subject) - %(authorname) (%(color:green)%(committerdate:relative)%(color:reset))'";
      lg = "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
      bclean = "!f() { git branch --merged master | grep -v '^\\*' | xargs -n 1 git branch -d; }; f";
    };
    extraConfig = {
      pull.ff = "only";
      # add fixup! 
      rebase.autosquash = true;
    };
    ignores = [
      "*.swo"
      "*.swp"
      ".DS_Store"
      ".bloop/"
      ".idea/"
      ".metals/"
      ".vscode/"
      "_esy/"
      "project/metals.sbt"
      "vim.log"
    ];
  };
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    history.extended = true;
    shellAliases = {
      # prints contents of paths on separate lines
      path = ''echo -e ''${PATH//:/\\n}'';
      # -I ignores binary files
      grep = "grep --color -I";
      ips = "ifconfig | awk '\$1 == \"inet\" {print \$2}'";
      hup = "home-manager switch && exec $SHELL";
      vim-debug = "vim -V9vim.log main.cpp";
    };
    oh-my-zsh = {
      enable = true;
      plugins = [
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
    '';
  };
  home.file.".sbt/1.0/plugins/plugins.sbt".source = ./plugins.sbt;
  home.file.".config/nvim/coc-settings.json".source = ./coc-settings.json;
}

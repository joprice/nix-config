{ config, pkgs, lib, ... }:

let async-profiler = pkgs.callPackage ./async-profiler.nix{}; in
{
  programs.home-manager.enable = true;
  home.username = "josephprice";
  home.homeDirectory = "/Users/josephprice";
  home.stateVersion = "20.09";
  home.packages = [
    pkgs.htop
    pkgs.sbt
    pkgs.vscode
    pkgs.jdk11
    pkgs.direnv
    pkgs.scala
    async-profiler
  ];
  nixpkgs.config.allowUnfree = true;
  home.sessionVariables = {
    JAVA_HOME = "${pkgs.jdk11.home}";
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
      vim-polyglot
      zenburn
      coc-nvim
      coc-metals
    ];
  };
  programs.git = {
    enable = true;
    userName = "Joseph Price";
    userEmail = "pricejosephd@gmail.com";
    aliases = {
      s = "status";
      co = "checkout";
    };
  };
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    history.extended = true;
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
    loginExtra = ''
      set -o vi
      bindkey "^?" backward-delete-char
    '';
  };
  home.file.".sbt/1.0/plugins/plugins.sbt".text = lib.fileContents ./plugins.sbt;
  home.file.".config/nvim/coc-settings.json".text = lib.fileContents ./coc-settings.json;
}

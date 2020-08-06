{ config, pkgs, lib, ... }:

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
  ];
  nixpkgs.config.allowUnfree = true;
  home.sessionVariables.JAVA_HOME = "${pkgs.jdk11.home}";
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
  };
  programs.neovim = {
    extraConfig = lib.fileContents ./vimrc;
    plugins =  with pkgs.vimPlugins; [
      vim-polyglot
    ];
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
}

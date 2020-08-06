{ config, pkgs, lib, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "josephprice";
  home.homeDirectory = "/Users/josephprice";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "20.09";
  home.packages = [
    pkgs.htop
    pkgs.sbt
    pkgs.vscode
    pkgs.jdk11
  ];
  nixpkgs.config.allowUnfree = true;
  home.sessionVariables.JAVA_HOME = "${pkgs.jdk11.home}";
  #programs.vim.enable = true;
  programs.neovim.enable = true;
  programs.neovim.viAlias = true;
  programs.neovim.vimAlias = true;
  programs.neovim.configure.customRC = lib.fileContents ./vimrc;
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
      #theme = "frozencow";
      #theme = "agnoster";
    };
    loginExtra = ''
      set -o vi
    #  setopt extendedglob
    #  source $HOME/.aliases
    #  bindkey '^R' history-incremental-pattern-search-backward
    #  bindkey '^F' history-incremental-pattern-search-forward
    '';
  };
}

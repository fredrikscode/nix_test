{ config, pkgs, ... }:

{
  home.username = "fredrik"; # Change this to your actual username
  home.homeDirectory = "/home/fredrik";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    neovim
    brave
    wezterm
    obsidian
    git
    tldr
    unzip
    unrar
    virt-manager
    bindTools
    deluge
    discord
    spotify
  ];

  services.git.enable = true;
  services.tldr.enable = true;

  programs.zsh.enable = true;
  programs.zsh.ohMyZsh.enable = true;
}
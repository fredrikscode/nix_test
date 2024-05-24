{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
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

  services.openssh.enable = true;
}
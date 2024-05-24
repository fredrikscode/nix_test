{ config, pkgs, ... }:

{
  imports = [
    ../modules/common.nix
  ];

  # Basic system settings
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.useDHCP = true;

  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    devices = [ "nodev" ];
  };

  time.timeZone = "America/Los_Angeles"; # Adjust to your timezone
  networking.hostName = "fredrik-test"; # Change this as needed

  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

  # Enable Hyprland
  services.xserver.enable = true;
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.hyprland.enable = true;

  networking.networkmanager.enable = true;

  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;
  hardware.opengl.extraPackages = with pkgs; [
    radeontop
  ];

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  virtualisation.libvirtd.enable = true;
}
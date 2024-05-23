# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, host, username, inputs, ... }:

{
  imports =
    [
      ./hardware.nix
      ./users.nix
      ../../modules/vm-guest-services.nix
      ../../modules/local-hardware-clock.nix
      ../../modules/amd-drivers.nix
      ../../modules/intel-drivers.nix
      ../../modules/nvidia-drivers.nix
      ../../modules/nvidia-prime-drivers.nix
    ];

  # Kernel
  boot.kernelPackages = pkgs.linuxPackages;

  # Boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernel.sysctl = {
    "vm.max_map_count" = 2147483642;
  };
  boot.tmp.useTmpfs = false;
  boot.tmp.tmpfsSize = "30%";
  boot.binfmt.registrations.appimage = {
    wrapInterpreterInShell = false;
    interpreter = "${pkgs.appimage-run}/bin/appimage-run";
    recognitionType = "magic";
    offset = 0;
    mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
    magicOrExtension = ''\x7fELF....AI\x02'';
  };

  # Networking
  networking.hostName = "${host}";
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Stockholm";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  programs = {
    hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
      xwayland.enable = true;
    };
    # firefox.enable = true;
    # dconf.enable = true;
    # seahorse.enable = true;
    # fuse.userAllowOther = true;
    # mtr.enable = true;
    # gnupg.agent = {
    #   enable = true;
    #   enableSSHSupport = true;
    # };
    virt-manager.enable = true;
    # steam = {
    #   enable = true;
    #   gamescopeSession.enable = true;
    #   remotePlay.openFirewall = true;
    #   dedicatedServer.openFirewall = true;
    # };
    # thunar = {
    #   enable = true;
    #   plugins = with pkgs.xfce; [ thunar-archive-plugin thunar-volman ];
    # };
  };

  nixpkgs.config.allowUnfree = true;

  users = {
    mutableUsers = true;
  };

  # System packages
  environment.systemPackages = 
  let
      sugar = pkgs.callPackage ../../pkgs/sddm-sugar-dark.nix { };
      tokyo-night = pkgs.libsForQt5.callPackage ../../pkgs/sddm-tokyo-night.nix { };
  in
  with pkgs; [
    vim
    wget
    git
    appimage-run
    sugar.sddm-sugar-dark
    tokyo-night
  ];

  services = {
    xserver = {
      enable = true;
      displayManager.sddm = {
        enable = true;
        autoNumlock = true;
        wayland.enable = true;
        theme = "sugar-dark";
      };
      desktopManager.cinnamon.enable = false;
      xkb = {
        layout = "se";
        variant = "";
      };
    };
    # smartd = {
    #   enable = true;
    #   autodetect = true;
    # };
    libinput.enable = true;
    openssh.enable = true;
    flatpak.enable = false;
    printing.enable = true;
    #gnome.gnome-keyring.enable = true;
    # avahi = {
    #   enable = true;
    #   nssmdns4 = true;
    #   openFirewall = true;
    # };
    #ipp-usb.enable = true;
    syncthing = {
      enable = false;
      user = "${username}";
      dataDir = "/home/${username}";
      configDir = "/home/${username}/.config/syncthing";
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    #rpcbind.enable = true;
    #nfs.server.enable = true;
  };

  hardware.sane = {
    enable = true;
    extraBackends = [ pkgs.sane-airscan ];
    disabledDefaultBackends = [ "escl" ];
  };
  hardware.logitech.wireless.enable = true;
  hardware.logitech.wireless.enableGraphical = true;
  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;

  # Optimization settings and garbage collection automation
  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      substituters = [ "https://hyprland.cachix.org" ];
      trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  # OpenGL
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

# Extra Module Options
  drivers.amdgpu.enable = true;
  drivers.nvidia.enable = false;
  drivers.nvidia-prime = {
    enable = false;
    intelBusID = "";
    nvidiaBusID = "";
  };
  drivers.intel.enable = false;
  vm.guest-services.enable = false;
  local.hardware-clock.enable = false;

  system.stateVersion = "23.11"; # Did you read the comment?

}


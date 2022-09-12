## Edit this configuration file to define what should be installed on
## your system.  Help is available in the configuration.nix(5) man page
## and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ ## Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  ## Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  networking.hostName = "nixos"; # Define your hostname.
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  ## Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  ## Enable networking
  networking.networkmanager.enable = true;

  ## Set your time zone.
  time.timeZone = "America/Los_Angeles";

  ## Select internationalisation properties.
  i18n.defaultLocale = "en_US.utf8";
  
  ## Mount Drive(s)
  ## Commented out becouse it's case by case need
  #fileSystems."/home/frozear/cardDrive" =
  #{ device = "/dev/disk/by-uuid/6474-DBFC";
  #  fsType = "exfat";
  #};

  ## Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    layout = "us";
    xkbVariant = "";
    libinput.enable = true;
    displayManager = {
        sddm.enable = true;
        defaultSession = "none+awesome";
    };
    windowManager.awesome = {
      enable = true;
      luaModules = with pkgs.luaPackages; [
        luarocks ## is the package manager for Lua modules
        luadbi-mysql ## Database abstraction layer
      ];

     };
   };
  ## Can't get this working - it's an attempt to configure monitors at startup
  # services.xserver.displayManager.setupCommands =''
  #   ${pkgs.arandr}/bin/xrandr --output eDP-1 --mode 2256x1504 --pos 1920x0 --rotate normal --output DP-1 --off --output DP-2 --off --output DP-3 --primary --mode 1920x1200 --pos 0x0 --rotate normal --output DP-4 --off
  # '';
   

  ## Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  ## Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.hplip ];

  ## Enable Compositor
  ## Needed to adjust kitty terminal opaqueness 
  services.picom.enable = true;

  ## Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    ## If you want to use JACK applications, uncomment this
    #jack.enable = true;

    ## use the example session manager (no others are packaged yet so this is enabled by default,
    ## no need to redefine it in your config for now)
    #media-session.enable = true;
  };


  ## Enable Fingerprint Reader
  # services.fprintd.enable = true;
 
  ## Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.frozear = {
    isNormalUser = true;
    description = "frozear";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    ];
  };

  ## Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  ## List packages installed in system profile. To search, run:
  ## $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim ## Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    kitty ## Terminal Emulator
    wget
    firefox
    thunderbird
    keepassxc
    feh ## Image viewer
    vlc
    ranger
    acpi ## For battery widget
    pywal ## a color palette renderer
    alsa-utils ## for Volume control
    playerctl ## for Media keys
    brightnessctl  ## for Backlight Brightness keys
    ffmpeg
    zathura ## PDF reader
    libreoffice
    transmission ## Torrent Client
    croc ## A file sharing application
    element-desktop
    git
    alacritty ## secondary terminal
    pciutils
    traceroute
    chromium
    (vscode-with-extensions.override {
       vscode = vscodium;
       vscodeExtensions = with vscode-extensions; [
         naumovs.color-highlight
       ]; 
     })
    rsync    
    spotify
    (let 
      my-python-packages = python-packages: with python-packages; [ 
        pygame
	## Very little of these work right now
	#pyqt5
        #folium
	#webbrowser
	#re
	##other python packages you want
      ];
      python-with-my-packages = python3.withPackages my-python-packages;
    in
    python-with-my-packages)
    arandr
  ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; ## Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; ## Open ports in the firewall for Source Dedicated Server
  };

  fonts.fonts = with pkgs; [
    fira-code
    fira-code-symbols
  ];


  ## Some programs need SUID wrappers, can be configured further or are
  ## started in user sessions.
  # programs.mt.enable = true;  ##<-------Might be messed up
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  ## List services that you want to enable:

  ## Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  ## Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  ## This value determines the NixOS release from which the default
  ## settings for stateful data, like file locations and database versions
  ## on your system were taken. It‘s perfectly fine and recommended to leave
  ## this value at the release version of the first install of this system.
  ## Before changing this value read the documentation for this option
  ## (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

}


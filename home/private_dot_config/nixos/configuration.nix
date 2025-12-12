# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable TPM support
  # https://nixos.wiki/wiki/TPM
  security.tpm2.enable = true;
  security.tpm2.pkcs11.enable = true;
  security.tpm2.tctiEnvironment.enable = true;

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time = {
    timeZone = "America/Los_Angeles";
    hardwareClockInLocalTime = true;
  };

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

  # Enable the GNOME Desktop Environment.
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  services.xserver = {
    enable = true;
    updateDbusEnvironment = true;

    # See `nixos/modules/services/x11/xserver.nix` and the list of included packages.
    excludePackages = [ pkgs.xterm ];

    # Configure keymap in X11
    xkb.layout = "us";
    xkb.variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mtaron = {
    isNormalUser = true;
    description = "Michael Taron";
    extraGroups = [
      "networkmanager"
      "wheel"
      "tss" # tss group has access to TPM devices
      "podman"
    ];
    packages = with pkgs; [
      # `chezmoi` is a dotfile manager
      # https://github.com/twpayne/chezmoi
      chezmoi

      # My current dev font
      # https://github.com/microsoft/cascadia-code
      cascadia-code

      alacritty

      # Zoom is a cloud-based video communications platform that enables virtual meetings, webinars,
      # messaging, and collaboration across devices.
      # https://zoom.us/
      zoom-us

      # `chromium` is a browser from Google.
      # https://www.chromium.org/
      chromium

      # `ghostty` is a new terminal emulator from Mitchell Hashimoto.
      # https://ghostty.org/
      ghostty

      # https://zed.dev/
      zed-editor

      # TODO: figure out how to use atuin's flake?
      atuin

      # kubernetes in docker
      # https://github.com/kubernetes-sigs/kind
      kind

      kubectl

      kubernetes-helm
    ];
  };

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  programs.git.enable = true;
  programs.git.lfs.enable = true;

  nixpkgs.config.allowUnfree = true;

  nix.channel.enable = false;

  nix.settings.experimental-features = [
    # Enable the new nix subcommands. See the manual on nix for details.
    # https://nixos.org/manual/nix/unstable/contributing/experimental-features#xp-feature-nix-command
    "nix-command"

    # Enable flakes. See the manual entry for nix flake for details.
    # https://nixos.org/manual/nix/unstable/command-ref/new-cli/nix3-flake
    "flakes"
  ];

  environment.systemPackages = with pkgs; [
    # `nix-output-monitor` is a fancy shell that makes nix-build much prettier.
    # https://github.com/maralorn/nix-output-monitor
    nix-output-monitor

    # `nixfmt` is the official formatter for Nix code in Nixpkgs.
    # https://github.com/NixOS/nixfmt
    nixfmt

    # Language server protocol for Nix
    # https://github.com/nix-community/nixd
    nixd

    # `bat` is a modern `cat` written in Rust with sweet features.
    # https://github.com/sharkdp/bat
    bat

    direnv

    # `fd` is a simple, fast and user-friendly alternative to find.
    # https://github.com/sharkdp/fd
    fd

    # https://github.com/fastfetch-cli/fastfetch
    fastfetch

    curl

    httpie

    vscode

    # `gh` is the command line GitHub client.
    # https://cli.github.com/
    gh

    tpm2-tools

    jq

    yq

    ripgrep

    shellcheck

    unzip

    xclip

    # `dutree` is a tool to analyze file system usage written in Rust
    # https://github.com/nachoparker/dutree
    dutree

    # `efibootmgr` is a tool to control EFI boots
    # https://github.com/rhboot/efibootmgr/
    efibootmgr

    # `efivar` is a tool to show and modify EFI variables
    # https://github.com/rhboot/efivar
    efivar

    # The `fixparts`, `cgdisk`, `sgdisk`, and `gdisk` programs are partitioning tools for GPT disks.
    # https://www.rodsbooks.com/gdisk/
    gptfdisk

    # `shfmt` is a shell formatter (sh/bash/mksh).
    # https://github.com/mvdan/sh
    shfmt

    # https://taskfile.dev/
    go-task

    # https://nixos.wiki/wiki/Yubikey
    pam_u2f

    # An extremely fast Python package and project manager, written in Rust.
    # https://docs.astral.sh/uv/
    uv

    # Fast, disk space efficient package manager.
    # https://pnpm.io/
    pnpm

    # `crane` is a tool for managing container images
    # https://github.com/google/go-containerregistry/blob/main/cmd/crane/doc/crane.md
    # https://github.com/google/go-containerregistry/blob/main/cmd/crane/recipes.md
    go-containerregistry
  ];

  # https://wiki.nixos.org/wiki/Podman
  virtualisation = {
    containers.enable = true;
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true; # Required for containers under podman-compose to be able to talk to each other.
    };
  };

  security.polkit.enable = true;

  # Run this command on a new machine to set up U2F for sudo:
  #  mkdir ~/.config/Yubico && pamu2fcfg > ~/.config/Yubico/u2f_keys
  security.pam.services = {
    sudo.u2fAuth = true;
  };

  programs._1password.enable = true;
  programs._1password-gui.enable = true;

  # Enable XDG portal support
  xdg.portal.enable = true;
  xdg.portal.configPackages = [ pkgs.gnome-session ];
  xdg.portal.extraPortals = [
    pkgs.xdg-desktop-portal-gnome
    pkgs.xdg-desktop-portal-gtk
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  system.stateVersion = "25.05";

}

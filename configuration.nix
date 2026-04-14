# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL
{
  pkgs,
  lib,
  # unstable,
  ...
}:
{
  imports = [
    ./system.nix
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  environment.systemPackages = with pkgs; [
    fish
    git
    dotnet-sdk
    docker
    ansible
    tmux
    opencode
    rustup
    gcc
    pkg-config
    openssl
    openssl.dev
    zlib
    zlib.dev
    typescript
    nodejs
    tsx
    typescript-language-server
    python313
  ];

  environment.sessionVariables = {
    PKG_CONFIG_PATH = lib.makeSearchPath "lib/pkgconfig" [
      pkgs.openssl.dev
      pkgs.zlib.dev
    ];

    OPENSSL_LIB_DIR = "${pkgs.openssl.out}/lib";
    OPENSSL_INCLUDE_DIR = "${pkgs.openssl.dev}/include";
    OPENSSL_DIR = pkgs.openssl.dev;
    OPENSSL_NO_VENDOR = "1";
  };

  wsl.enable = true;
  wsl.defaultUser = "nixos";

  nixpkgs.config.allowUnfree = true;

  users.users.nixos = {
    isNormalUser = true;
    description = "nixos";
    extraGroups = [
      "networkmanager"
      "wheel"
      "nix"
      "docker"
    ];
    shell = pkgs.fish;
  };

  virtualisation.docker = {
    enable = true;
    daemon.settings = {
      log-driver = "json-file";
      log-opts = {
        max-size = "10m";
        max-file = "3";
      };
    };
  };

  programs.fish.enable = true;
  programs.nix-ld.enable = true;

  programs.tmux = {
    enable = true;
    plugins = with pkgs; [
      tmuxPlugins.minimal-tmux-status
    ];
    extraConfig = ''
      set -g @minimal-tmux-use-arrow true
      set -g @minimal-tmux-right-arrow ""
      set -g @minimal-tmux-left-arrow ""
    '';
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}

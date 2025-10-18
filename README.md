# Homelab NixOS Configuration

This repository contains my personal NixOS configuration. It is likely to evolve as I learn more about the nix language.

## Table of Contents

- [Overview](#overview)
- [Using this Flake](#using-this-flake)

## Overview

This configuration leverages a modular approach.

## Using this Flake

1.  **Grab and install** a copy of [NixOS](https://nixos.org/download/) and install it to a drive.
    You can alternatively PXE boot from netboot.xyz and launch the NixOS livecd from the installer menu.
    Walk through the installer to generate a config at `/etc/nixos/configuration.nix`.
    Make note of the hardware configuration generated at `/etc/nixos/hardware-configuration.nix`.
    Reboot.

2.  **Modify** and verify appropriate changes to `config/hosts/<your-hostname>`.

3.  **Install this Flake** by running:
    ```bash
    sudo nixos-rebuild switch --flake 'github:SparksD2145/nixosConfig#workstationName' && systemctl reboot
    ```

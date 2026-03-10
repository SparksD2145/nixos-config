#!/bin/bash

# Accept hostname as an argument
if [ -z "$1" ]; then
    system_hostname = $1
else
    exit 1;
fi

sudo nixos-rebuild switch --flake "github:SparksD2145/nixos-config#${system_hostname}"

# Navigate to your configuration directory
cd ~/nix_test

# Update flake inputs
nix flake update

# Rebuild and switch to the new NixOS configuration
sudo nixos-rebuild switch --flake .#fredrik-test

# Apply the updated Home Manager configuration
home-manager switch --flake .#fredrik
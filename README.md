# nixos-config

My config for the working environment.

To use this config:

```bash
git clone https://github.com/Themanwhosmellslikesugar/nixos-config.git ~/nixos-config
sudo nixos-rebuild switch --flake ~/nixos-config

# Or reload home manager configs without sudo
nix run nixpkgs#home-manager -- switch --flake ~/nixos-config -b backup
```

To enable flake add this to `/etc/nixos/configuration.nix`:

```nix
nix.extraOptions = ''
  experimental-features = nix-command flakes
'';
```

To modify this config:

```bash
cd ~/nixos-config
direnv allow
zeditor .
```

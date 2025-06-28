# nixos-config

My config for the working environment.

To use this config:

```bash
git clone https://github.com/estromenko/nixos-config ~/nixos-config
sudo nixos-rebuild switch --flake ~/nixos-config
```

To modify this config:

```bash
cd ~/nixos-config
direnv allow
zeditor .
```

# nixos-config

My config for the working environment.

To use this config:

```bash
git clone https://github.com/Themanwhosmellslikesugar/nixos-config.git ~/nixos-config
sudo nixos-rebuild switch --flake ~/nixos-config#themanwhosmellslikesugar-MG

# Or reload home manager configs without sudo
nix run nixpkgs#home-manager -- switch --flake ~/nixos-config#themanwhosmellslikesugar -b backup
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

## Configuration layout

```text
general/
  configuration.nix         Shared system settings, bootloader and compatibility baseline
  desktop.nix               Plasma, login manager, audio and desktop services
  home-manager/             Shared user settings, applications and wallpaper
  disko.nix                 Optional disk layout for NEW installations
current/
  default.nix               Current hostname and machine-specific module imports
  hardware-configuration.nix Generated hardware settings, without filesystems
  kernel.nix                CachyOS kernel, scheduler, module blacklist and workarounds
  disko.nix                 Existing disk, partition UUIDs and formatting protection
```

`flake.nix` connects the shared modules to each machine through `mkHost`.
The Plasma Manager and nix-index-database Home Manager modules are connected
there for both system-managed and standalone Home Manager configurations.

Put manual kernel changes in `current/kernel.nix`, rather than editing the
generated hardware configuration. Shared `/tmp` and zram settings belong to
`general/configuration.nix`, along with the shared UEFI bootloader settings and
`system.stateVersion = "25.05"`. This version selects compatibility defaults for
the configuration; it does not track the current NixOS release and is kept when
upgrading.

## Adding another machine

Create a separate directory alongside `current`, generate the hardware
configuration on that machine, and add a `default.nix`. For example, for a new
UEFI installation:

```bash
mkdir -p new-machine
nixos-generate-config --no-filesystems --show-hardware-config > new-machine/hardware-configuration.nix
```

```nix
# new-machine/default.nix
{
  imports = [
    ./hardware-configuration.nix
    (import ../general/disko.nix {
      disk = "/dev/disk/by-id/REPLACE-WITH-THE-NEW-DISK-ID";
      swapSize = "16G";
    })
  ];

  networking.hostName = "new-machine";
}
```

Add `nixosConfigurations.new-machine = mkHost ./new-machine;` inside the output
attribute set in `flake.nix`. Add the new files to Git before evaluating the
flake. The generated hardware configuration selects the platform and CPU
microcode. GPU drivers and hardware workarounds, if required, belong to the
new machine's directory. It uses the standard NixOS kernel unless you explicitly
select another kernel; the current machine's Intel settings, CachyOS x86_64-v3
kernel, module blacklist and touchpad workaround are not shared.

`general/disko.nix` creates EFI (512 MiB), swap (configurable) and ext4 root
(remaining space), with new UUIDs generated during installation. This template
is for formatting the selected disk during a fresh installation. For a machine
with data to preserve, describe its existing partitions in its own `disko.nix`
instead, as done for `current`.

The shared user configuration keeps the same username and home directory on
each machine. Personal files, SSH keys and other credentials must be transferred
separately. The standalone Home Manager output currently uses `x86_64-linux`;
adjust its `system` in `flake.nix` for a different architecture.

## Current disk

`current/disko.nix` generates mount settings using the existing partition UUIDs.
It does not import the fresh-install template. Ordinary `nixos-rebuild` does not
partition or format disks. `destroy = false` excludes the current disk from the
destroy stage, and the GPT `preCreateHook` refuses the creation stage before
partitioning or formatting.

Do not run Disko's disk operation scripts for the existing-disk migration.
When regenerating hardware configuration, use `--no-filesystems` to avoid
duplicating Disko's filesystem and swap declarations.

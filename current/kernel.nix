# Kernel choices and workarounds for this machine, kept outside the generated file.
{
  pkgs,
  inputs,
  ...
}: {
  # Match the compiler and dependencies used by the CachyOS binary caches.
  nixpkgs.overlays = [inputs.nix-cachyos-kernel.overlays.pinned];
  boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest-lto-x86_64-v3;

  # Caches documented at https://github.com/xddxdd/nix-cachyos-kernel#binary-cache
  nix.settings = {
    substituters = [
      "https://attic.xuyh0120.win/lantian"
      "https://cache.xinux.uz"
    ];
    trusted-public-keys = [
      "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
      "cache.xinux.uz:BXCrtqejFjWzWEB9YuGB7X2MV4ttBur1N8BkwQRdH+0="
    ];
  };
  services.scx.enable = true;

  boot.kernelParams = [
    "mitigations=off"
    # Avoid touchpad click to tap (clickpad) bug. For more detail see:
    # https://wiki.archlinux.org/title/Touchpad_Synaptics#Touchpad_does_not_work_after_resuming_from_hibernate/suspend
    "psmouse.synaptics_intertouch=0"
  ];

  boot.blacklistedKernelModules = [
    # Obscure network protocols
    "ax25"
    "netrom"
    "rose"
    # Old or rare or insufficiently audited filesystems
    "adfs"
    "affs"
    "bfs"
    "befs"
    "cifs"
    "cramfs"
    "efs"
    "exofs"
    "freevxfs"
    "gfs2"
    "hfs"
    "hfsplus"
    "hpfs"
    "jffs2"
    "jfs"
    "ksmbd"
    "minix"
    "nfsv4"
    "nfsv3"
    "nfs"
    "nilfs2"
    "omfs"
    "qnx4"
    "qnx6"
    "sysv"
    "udf"
    "ufs"
    "vivid"
    "floppy"
    "parport"
    # Something else
    "appletalk"
    "atm"
    "can"
    "dccp"
    "decnet"
    "econet"
    "ipx"
    "n-hdlc"
    "p8022"
    "p8023"
    "psnap"
    "rds"
    "sctp"
    "tipc"
    "x25"
    # Unused sensors
    "kfifo_buf"
    "cm32181"
    # Unused io
    "joydev" # joystick
    "mac_hid" # mac mouse
    # FireWire
    "firewire-core"
    "firewire-ohci"
    "firewire-sbp2"
  ];
}

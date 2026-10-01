{
  # Adopt the installed disk. nixos-rebuild only uses the generated mount config.
  # Partitioning/formatting scripts are deliberately blocked for this machine.
  disko.devices.disk.main = {
    type = "disk";
    device = "/dev/disk/by-id/nvme-eui.6479a777e0900050";
    destroy = false;

    content = {
      type = "gpt";
      preCreateHook = ''
        echo "Refusing to repartition or format the installed system disk." >&2
        exit 1
      '';

      # Exact existing boundaries, in 512-byte sectors. Priorities keep p1/p2/p3.
      partitions = {
        esp = {
          priority = 1;
          type = "EF00";
          uuid = "9c94abe6-ee88-43ba-baf2-f7cfdba21719";
          label = "EFI";
          start = "4096";
          end = "1052671";
          alignment = 1;
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
            mountOptions = [ "fmask=0077" "dmask=0077" ];
            extraArgs = [ "-F" "32" "-i" "41D7DB05" ];
          };
        };

        root = {
          priority = 2;
          type = "8300";
          uuid = "7623e1b0-f93f-4ff9-8612-66183a1b89e0";
          label = "root";
          start = "1052672";
          end = "1964982639";
          alignment = 1;
          content = {
            type = "filesystem";
            format = "ext4";
            mountpoint = "/";
            mountOptions = [ "defaults" ];
            extraArgs = [ "-U" "c72bbfbc-0fdf-4c67-87e1-30bc9748b3f8" ];
          };
        };

        swap = {
          priority = 3;
          type = "8200";
          uuid = "dd3b0781-f08f-4c83-bc63-56ab6e336eaa";
          label = "";
          start = "1964982640";
          end = "2000397734";
          alignment = 1;
          content = {
            type = "swap";
            extraArgs = [ "-U" "78a3c734-3807-4edf-b7cb-cc15d1b46f45" "-L" "swap" ];
          };
        };
      };
    };
  };
}

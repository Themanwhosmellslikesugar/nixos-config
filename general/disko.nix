# Opt-in layout for a NEW installation; this is not imported by the current host.
# Creating this layout partitions and formats the selected disk.
{
  disk,
  swapSize ? "16G",
}: {
  disko.devices.disk.main = {
    type = "disk";
    device = disk;
    content = {
      type = "gpt";
      partitions = {
        esp = {
          priority = 1;
          type = "EF00";
          size = "512M";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
            mountOptions = ["fmask=0077" "dmask=0077"];
          };
        };

        swap = {
          priority = 2;
          size = swapSize;
          content.type = "swap";
        };

        root = {
          priority = 3;
          size = "100%";
          content = {
            type = "filesystem";
            format = "ext4";
            mountpoint = "/";
            mountOptions = ["defaults"];
          };
        };
      };
    };
  };
}

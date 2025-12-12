{
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/347c4732-97bf-4801-95b2-48db950f8e65";
    fsType = "ext4";
  };
  boot.initrd.luks.devices."luks-52908bb0-8ecc-4db1-a09a-2ff9e6f57816".device =
    "/dev/disk/by-uuid/52908bb0-8ecc-4db1-a09a-2ff9e6f57816";
  boot.initrd.luks.devices."luks-dfd46d89-2fea-4478-8e83-dc5756a0bcbb".device =
    "/dev/disk/by-uuid/dfd46d89-2fea-4478-8e83-dc5756a0bcbb";

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/7D91-6809";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/e3143082-81e3-4d36-902a-a4b658702b86"; }
  ];
}

{
  # Enable AMD microcode updates and firmware because this is an AMD system.
  hardware.enableRedistributableFirmware = true;
  hardware.cpu.amd.updateMicrocode = true;

  # Enable the KVM kernel module for AMD processors so that virtual machines can use hardware
  # acceleration, rather than pure software emulation.
  boot.kernelModules = [ "kvm-amd" ];
}

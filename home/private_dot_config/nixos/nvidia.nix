{ config, pkgs, ...}:
{
  # Use the latest NVIDIA open drivers. Under no circumstances use the `nouveau` open
  # drivers, as they are not performant and have many bugs.
  # See https://www.nvidia.com/en-us/drivers/unix/linux-amd64-display-archive/
  # and https://github.com/NVIDIA/open-gpu-kernel-modules/
  boot.blacklistedKernelModules = [ "nouveau" ];
  hardware.nvidia.open = true;
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.latest.override {
    disable32Bit = true;
  };

  # Try to address glitches after sleep/resume.
  hardware.nvidia.powerManagement.enable = true;

  # The zone of "Are we Wayland yet?" with the answer "mostly yes!".
  hardware.nvidia.modesetting.enable = true;

  # Turn off the NVIDIA settings GUI. It's not for Wayland yet.
  hardware.nvidia.nvidiaSettings = false;

  # Turn on the NVIDIA NixOS module which keys on this value.
  services.xserver.videoDrivers = [ "nvidia" ];

  environment.systemPackages = with pkgs; [
    # Small utility to dump info about DRM devices.
    # https://gitlab.freedesktop.org/emersion/drm_info
    drm_info

    # NVIDIA's Wayland EGL External Platform library
    # https://github.com/NVIDIA/egl-wayland
    egl-wayland

    # Tool for reading and parsing EDID data from monitors
    # http://www.polypux.org/projects/read-edid/
    read-edid

    # Provides the `vkcube`, `vkcubepp`, `vkcube-wayland`, and `vulkaninfo` tools.
    # https://github.com/KhronosGroup/Vulkan-Tools
    vulkan-tools
  ];
}

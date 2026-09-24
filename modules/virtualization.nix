{ ... }:

{
  virtualisation = {
    graphics = true;
    qemu.options = [
      "-vga virtio"
      "-display gtk"
      "-device usb-tablet"
    ];

    cores = 6;
    memorySize = 4096;
    resolution = {
      x = 1920;
      y = 1080;
    };
  };
}

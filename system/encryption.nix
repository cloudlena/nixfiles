{
  # Set up keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  # Enable swap on luks
  boot.initrd.luks.devices."luks-58a9f60d-bf2d-4c94-8f08-8e29a4083728".device = "/dev/disk/by-uuid/58a9f60d-bf2d-4c94-8f08-8e29a4083728";
  boot.initrd.luks.devices."luks-58a9f60d-bf2d-4c94-8f08-8e29a4083728".keyFile = "/crypto_keyfile.bin";
}


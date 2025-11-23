{
  pkgs,
  lib,
  config,
  ...
}:
{
  # Enable libvirt virtualisation
  virtualisation = {
    libvirtd = {
      # Enable the libvirt daemon
      enable = true;

      # Enable the QEMU/KVM hypervisor
      qemu = {
        package = pkgs.qemu_kvm;
        swtpm.enable = true;
        ovmf.enable = true;
        ovmf.packages = [ pkgs.OVMFFull.fd ];
      };
      extraConfig = ''uri_default = "qemu:///system"'';
    };

    # Enable SPICE USB redirection
    spiceUSBRedirection.enable = true;
  };

  # Add the current user to the libvirt group
  users.users."${config.users.default.username}".extraGroups = [ "libvirtd" ];

  # Add the necessary packages for virtio and SPICE support
  environment.systemPackages = with pkgs; [
    spice
    spice-gtk
    spice-protocol
    virt-viewer
    virt-manager
    spice-gtk
    spice-protocol
    virtio-win
    win-spice
    freerdp
    virtiofsd
  ];

  # Enable the virt-manager GUI
  programs.dconf.enable = true;
  programs.virt-manager.enable = true;

  # Enable the SPICE VDagent
  services.spice-vdagentd.enable = true;

  # Force disable libvirt service so that it is not started at boot
  systemd.services.libvirtd.wantedBy = lib.mkForce [ ];
  systemd.services.libvirt-guests.wantedBy = lib.mkForce [ ];
  systemd.services.spice-vdagentd.wantedBy = lib.mkForce [ ];
}

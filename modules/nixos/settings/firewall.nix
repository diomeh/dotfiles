{ ... }:
{
  networking.firewall = {
    enable = true;

    allowedTCPPorts = [
      80
      443
    ];
    allowedTCPPortRanges = [
      {
        from = 1714;
        to = 1764;
      } # KDE Connect
    ];

    allowedUDPPorts = [
      67 # DHCP for dnsmasq
    ];
    allowedUDPPortRanges = [
      {
        from = 1714;
        to = 1764;
      } # KDE Connect
    ];

    trustedInterfaces = [
      "wlo1" # Wifi interface
    ];
  };

  # Enable nftables firewall backend
  networking.nftables.enable = true;

  # Set cloudflare DNS servers
  networking.nameservers = [
    "1.1.1.1"
    "1.0.0.1"
  ];

  # DNS resolver
  # Can be either dnsmasq or systemd-resolved but not both

  # Hotspot related DNS resolver issue, systemd-resolved may be a working alternative
  # services.dnsmasq = {
  #   enable = true;
  #   settings = {
  #     bind-interfaces = true;
  #     server = [
  #       "1.1.1.1"
  #       "1.0.0.1"
  #     ];
  #   };
  # };

  # Needed for Mullvad VPN (see: https://discourse.nixos.org/t/connected-to-mullvadvpn-but-no-internet-connection/35803/8?u=lion)
  services.resolved = {
    enable = true;
    dnssec = "true";
    domains = [ "~." ];
    fallbackDns = [
      "1.1.1.1"
      "1.0.0.1"
    ];
    dnsovertls = "true";
  };
}

{ ... }:

{
  services.samba = {
    enable = true;
    openFirewall = true; # Automatically open firewall ports for Samba
    winbindd.enable = true; # Enable Winbind (for AD/Windows domain integration)
    nsswins = true; # Enable NetBIOS name resolution

    # Samba server configuration (replaces the deprecated extraConfig)
    settings = {
      global = {
        workgroup = "WORKGROUP"; # Set the Windows workgroup name
        "server string" = "smbnix"; # Description of the Samba server
        "netbios name" = "smbnix"; # NetBIOS name of the server
        security = "user"; # Use user-level security (requires valid Samba users)
        "use sendfile" = "yes"; # Enable sendfile optimization
        "max protocol" = "smb2"; # Limit maximum SMB protocol
        # Note: localhost includes IPv6 loopback ::1
        "hosts allow" = "192.168.0. 127.0.0.1 localhost"; # Allowed hosts
        "hosts deny" = "0.0.0.0/0"; # Denied hosts
        "guest account" = "nobody"; # Account to use for guest access
        "map to guest" = "bad user"; # Map invalid users to guest
      };

      # Define shared folders
      public = {
        path = "/mnt/Shares/Public"; # Path to the public share
        browseable = "yes"; # Make visible in network browsing
        "read only" = "no"; # Allow write access
        "guest ok" = "yes"; # Allow guest access
        "create mask" = "0644"; # Permissions for new files
        "directory mask" = "0755"; # Permissions for new directories
        "force user" = "username"; # Force all files to this user
        "force group" = "groupname"; # Force all files to this group
      };
      private = {
        path = "/mnt/Shares/Private"; # Path to the private share
        browseable = "yes"; # Make visible in network browsing
        "read only" = "no"; # Allow write access
        "guest ok" = "no"; # Guest access not allowed
        "create mask" = "0644"; # Permissions for new files
        "directory mask" = "0755"; # Permissions for new directories
        "force user" = "username"; # Force all files to this user
        "force group" = "groupname"; # Force all files to this group
      };
    };
  };

  # Enable WS-Discovery (for Windows network discovery)
  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };

  # Firewall settings
  networking.firewall.allowPing = true; # Allow ICMP ping
  networking.firewall.extraCommands = ''
    # Helper for NetBIOS name service traffic on UDP port 137
    iptables -t raw -A OUTPUT -p udp -m udp --dport 137 -j CT --helper netbios-ns
  '';
}

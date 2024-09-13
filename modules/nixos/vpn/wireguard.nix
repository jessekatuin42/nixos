{ config, pkgs, ... }:

{
  # Enable the WireGuard interface and configure it
  networking.firewall = {
    allowedUDPPorts = [ 51400 ]; # Ensure this port is allowed for WireGuard
  };

  networking.wireguard.interfaces = {
    wg0 = {
      # IP address and subnet of the WireGuard interface
      ips = [ "192.168.200.8/32" ];

      # The port WireGuard should listen on
      listenPort = 51400;

      # Path to the private key file
      privateKeyFile = "/etc/wireguard/privatekey";

      peers = [
        {
          # Public key of the peer
          publicKey = "u2I3ullKW17xKDdvI+NBqO1fZKIEA1UYo9Zo/KvIBzM=";

          # Allowed IPs for this peer
          allowedIPs = [ "192.168.200.1/32" "192.168.200.8/32" "0.0.0.0/0" ];

          # Endpoint of the peer
          endpoint = "91.192.36.181:51400";

          # Keepalive setting
          persistentKeepalive = 25;
        }
      ];
    };
  };
}


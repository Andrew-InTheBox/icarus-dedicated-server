# ICARUS Dedicated Server -- Home Setup Guide (2025)

## Overview

This document describes the full configuration for hosting an ICARUS
dedicated server on a Windows PC located on an isolated VLAN behind a
UniFi UDM router.

### Server Machine

-   **IP Address:** `<SERVER_IP>` (configured in .env)
-   **VLAN:** Server VLAN
-   **OS:** Windows
-   **Dedicated Server AppID:** `2089300`

------------------------------------------------------------------------

## Network Ports

  Purpose             Port        Protocol
  ------------------- ----------- ----------
  Game Traffic        **17777**   UDP
  Query / Discovery   **27025**   UDP

------------------------------------------------------------------------

## UniFi UDM Configuration

### Port Forwarding (WAN → Server)

Create the following rules:

#### ICARUS Game

    UDP <GAME_PORT>  →  <SERVER_IP> : <GAME_PORT>

#### ICARUS Query

    UDP <QUERY_PORT>  →  <SERVER_IP> : <QUERY_PORT>

### Inter‑VLAN Firewall Rule

Allow your main LAN to reach the ICARUS VLAN:

  Setting       Value
  ------------- ---------------------
  Action        Accept
  Protocol      All
  Source        Main LAN subnet
  Destination   <SERVER_VLAN_SUBNET>

------------------------------------------------------------------------

## Configuration

### 1. Copy and configure your .env file

``` powershell
copy .env.example .env
```

Edit `.env` and set your specific values (server IP, passwords, ports, etc.)

**Important:** Never commit `.env` to source control! It contains sensitive information.

------------------------------------------------------------------------

## Windows Firewall (Server PC)

Run the automation script (reads from .env):

``` powershell
.\scripts\04-firewall.ps1
```

------------------------------------------------------------------------

## Starting the Server

Run the automation script (reads from .env):

``` powershell
.\scripts\05-run.ps1
```

Or override specific values:

``` powershell
.\scripts\05-run.ps1 -ServerName "My Server" -GamePort 17777 -QueryPort 27025
```

------------------------------------------------------------------------

## How Players Connect

### From Inside Your Network (LAN)

    <SERVER_IP>:<QUERY_PORT>

### From the Internet

    <PUBLIC_IP>:<QUERY_PORT>

------------------------------------------------------------------------

## Troubleshooting

-   Verify both ports are forwarded correctly on the UDM.
-   Confirm Windows Firewall rules exist on the server.
-   Ensure ICARUS server version matches client version.
-   Use a phone on cellular data to test external connectivity.

------------------------------------------------------------------------

## Optional Enhancements

-   Run the server as a Windows Service for automatic startup.
-   Schedule nightly updates using the provided PowerShell automation.
-   Enable NAT Loopback on the UDM if you want to test your public IP
    from inside your network.

------------------------------------------------------------------------

Happy prospecting! 🚀

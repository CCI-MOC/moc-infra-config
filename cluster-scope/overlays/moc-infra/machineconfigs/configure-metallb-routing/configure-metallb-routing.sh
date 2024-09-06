#!/bin/bash

if [[ -z "$HOSTNAME" ]]; then
  echo "ERROR: cannot continue without HOSTNAME" >&2
  exit 1
fi

node_number=${HOSTNAME##*-}
public_address="129.10.5.$((50 + node_number))"
public_interface=ens3f0np0

echo "assigning address $public_address for $HOSTNAME"

# put public interface in loose reverse path filter mode
sysctl "net.ipv4.conf.$public_interface.rp_filter=2"

# enable ip forwarding
sysctl "net.ipv4.ip_forward=1"

# add ip address to the public interface
ip addr add "${public_address}/24" dev "$public_interface"
ip link set "$public_interface" up

# set up policy routing so that replies go out the
# public interface
ip rule add prio 10000 lookup main suppress_prefixlength 0
ip rule add prio 10127 fwmark 0x127 lookup 127
ip route add default via 129.10.5.1 table 127

nft -f- <<EOF
table ip metallb {
  chain INPUT {
    type filter hook input priority filter; policy accept;

    # drop all packets on public interface inbound to host
    iifname "$public_interface" counter drop
  }

  chain PREROUTING {
    type filter hook prerouting priority mangle; policy accept;

    # copy connection mark to packet mark
    counter meta mark set ct mark

    # if packet is already marked, exit this chain
    meta mark != 0x00000000 counter return

    # apply mark 0x127 to packets coming in the public interface
    iifname "$public_interface" counter meta mark set 0x127
  }

  chain POSTROUTING {
    type filter hook postrouting priority mangle; policy accept;

    # copy packet mark to connection mark
    counter ct mark set mark
  }
}
EOF

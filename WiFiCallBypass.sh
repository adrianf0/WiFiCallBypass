#!/bin/bash

# Default values
TMARK="0x01"
ROUTE_TABLE="100"

if [ "$EUID" -ne 0 ]; then
  echo "Please run as root (e.g., sudo $0 ...)"
  exit 1
fi

# Help message
usage() {
  echo "Usage: $0 --mnc <MNC> --mcc <MCC> --ssh <SSH_CONNECTION> [--tmark <TMARK>]"
  echo "Example: $0 --mnc 001 --mcc 228 --ssh user@host [--tmark 0x01]"
  exit 1
}

# Parse named parameters
while [[ $# -gt 0 ]]; do
  key="$1"
  case $key in
    --mnc)
      MNC="$2"
      shift; shift
      ;;
    --mcc)
      MCC="$2"
      shift; shift
      ;;
    --ssh)
      SSH_CONNECTION="$2"
      shift; shift
      ;;
    --tmark)
      TMARK="$2"
      shift; shift
      ;;
    -h|--help)
      usage
      ;;
    *)
      echo "Unknown option: $1"
      usage
      ;;
  esac
done

# Check required parameters
if [[ -z "$MNC" || -z "$MCC" || -z "$SSH_CONNECTION" ]]; then
  usage
fi

# Required by TPROXY (https://sshuttle.readthedocs.io/en/stable/tproxy.html)
ip route add local default dev lo table ${ROUTE_TABLE}
ip rule add fwmark ${TMARK} lookup ${ROUTE_TABLE}
ip -6 route add local default dev lo table ${ROUTE_TABLE}
ip -6 rule add fwmark ${TMARK} lookup ${ROUTE_TABLE}

# Listen on all ports, as we might want to route traffic from, e.g. virtual AP interfaces
sshuttle -t ${TMARK} --method=tproxy -r ${SSH_CONNECTION} -e "ssh -o PubkeyAuthentication=no" --listen 0.0.0.0:0 epdg.epc.mnc${MNC}.mcc${MCC}.pub.3gppnetwork.org

ip route flush table ${ROUTE_TABLE}
ip rule del fwmark ${TMARK} lookup ${ROUTE_TABLE}
ip -6 route flush table ${ROUTE_TABLE}
ip -6 rule del fwmark ${TMARK} lookup ${ROUTE_TABLE}

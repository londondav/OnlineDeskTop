#!/usr/bin/env bash
# Installs the OnlineDeskTop server on a fresh Ubuntu/Debian VPS.
# Usage (as root):  bash install.sh
set -euo pipefail

DIR=/opt/onlinedesktop
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

if ! command -v docker >/dev/null 2>&1; then
  echo ">>> Installing Docker"
  curl -fsSL https://get.docker.com | sh
fi

mkdir -p "$DIR"
cp "$SCRIPT_DIR/docker-compose.yml" "$DIR/docker-compose.yml"
cd "$DIR"

if command -v ufw >/dev/null 2>&1 && ufw status | grep -q "Status: active"; then
  echo ">>> Opening firewall ports"
  ufw allow 21115:21117/tcp
  ufw allow 21116/udp
fi

echo ">>> Starting containers"
docker compose up -d

echo ">>> Waiting for the server key"
for _ in $(seq 1 30); do
  [ -s "$DIR/data/id_ed25519.pub" ] && break
  sleep 1
done

IP="$(curl -fsS https://api.ipify.org || hostname -I | awk '{print $1}')"
echo
echo "=============================================="
echo " OnlineDeskTop server is running"
echo " Server address : $IP"
echo " Public key     : $(cat "$DIR/data/id_ed25519.pub")"
echo "=============================================="
echo "Send both values to Claude to build them into the app."
echo "Keep $DIR/data/id_ed25519 secret and back it up."

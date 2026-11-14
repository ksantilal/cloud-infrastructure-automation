#!/bin/bash

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TF_DIR="${REPO_ROOT}/terraform/environments/dev"
INVENTORY_FILE="${REPO_ROOT}/ansible/inventory/dev.ini"

mapfile -t APP_IPS < <(
  cd "${TF_DIR}"
  terraform output -json app_private_ips | jq -r '.[]'
)

if [ "${#APP_IPS[@]}" -eq 0 ]; then
  echo "No application server IPs found."
  exit 1
fi

{
  echo "[app_servers]"

  for i in "${!APP_IPS[@]}"; do
    echo "app-$((i + 1)) ansible_host=${APP_IPS[$i]}"
  done

  echo
  echo "[app_servers:vars]"
  echo "ansible_user=ubuntu"
  echo "ansible_ssh_private_key_file=/home/ubuntu/.ssh/kloudbuild-project1"
  echo "ansible_python_interpreter=/usr/bin/python3"

} > "${INVENTORY_FILE}"

echo "Generated ${INVENTORY_FILE}"

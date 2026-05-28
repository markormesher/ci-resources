#!/usr/bin/env bash
set -euo pipefail

apt update
apt install -y --no-install-recommends curl ca-certificates jq

latest_tag=$(curl --fail https://api.github.com/repos/go-task/task/releases/latest | jq -rc '.tag_name')
current_tag=$(cat /tedium/repo/setup/.task-version)

echo "Latest version: ${latest_tag}"
echo "Current version: ${current_tag}"

if [[ "${latest_tag}" != "${current_tag}" ]]; then
  wget https://github.com/go-task/task/releases/download/${latest_tag}/task_linux_amd64.tar.gz
  wget https://github.com/go-task/task/releases/download/${latest_tag}/task_checksums.txt
  sha256sum --check --ignore-missing task_checksums.txt
  mv task_linux_amd64.tar.gz /tedium/repo/setup/.
  echo "${latest_tag}" > /tedium/repo/setup/.task-version
fi

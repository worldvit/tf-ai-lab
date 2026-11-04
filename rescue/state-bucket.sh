#!/bin/bash
# 상태 버킷 확인·생성 — 저장소 맨 위 폴더에서: bash rescue/state-bucket.sh
# 이미 있으면 이름만 출력하고, 없으면 bootstrap/state-bucket으로 만든다
set -euo pipefail
cd "$(dirname "$0")/.."
B=$(aws s3api list-buckets --query "Buckets[?starts_with(Name,'tfai-state-')].Name | [0]" --output text)
if [ "$B" = "None" ] || [ -z "$B" ]; then
  terraform -chdir=bootstrap/state-bucket init -input=false >/dev/null
  terraform -chdir=bootstrap/state-bucket apply -auto-approve -input=false >/dev/null
  B=$(terraform -chdir=bootstrap/state-bucket output -raw bucket)
fi
echo "$B"

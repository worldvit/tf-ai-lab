#!/bin/bash
# 앞 실습을 못 끝냈을 경우 시작점 — 저장소 맨 위 폴더에서: bash rescue/day3-start.sh
# 3계층 실습은 새 코드로 시작하므로 필요한 것은 상태 버킷과 도구뿐이다
set -euo pipefail
cd "$(dirname "$0")/.."
export AWS_REGION=${AWS_REGION:-ap-northeast-2}
for t in terraform tflint checkov trivy; do
  command -v $t >/dev/null && echo "[OK] $t $($t --version 2>/dev/null | head -1)" || echo "[없음] $t → 작업용 EC2 스택을 다시 만들기"
done
B=$(bash rescue/state-bucket.sh)
echo "[OK] 상태 버킷 $B"
echo "다음 명령으로 시작: cd day3/lab && terraform init -backend-config=\"bucket=$B\""

#!/bin/bash
# 앞 실습을 못 끝냈을 경우 시작점 — 저장소 맨 위 폴더에서: bash rescue/day4-start.sh
# Day 4는 새 코드(OIDC · 파이프라인 · 카드)로 시작하므로 상태 버킷과 저장소 주소만 있으면 된다
set -euo pipefail
cd "$(dirname "$0")/.."
export AWS_REGION=${AWS_REGION:-ap-northeast-2}
B=$(bash rescue/state-bucket.sh)
R=$(git remote get-url origin | sed -E 's#.*github.com[:/]##; s#\.git$##')
echo "[OK] 상태 버킷 $B"
echo "[OK] 내 저장소 $R"
n=$(terraform -chdir=day3/lab state list 2>/dev/null | wc -l || true)
[ "${n:-0}" = 0 ] && echo "[OK] Day 3 리소스 없음" || echo "[남음] Day 3 리소스 ${n}개 → terraform -chdir=day3/lab destroy"
echo "다음: cd day4/oidc && terraform init -backend-config=\"bucket=$B\" && terraform apply -var github_repo=$R"

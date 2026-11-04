#!/bin/bash
# Day 4 채점 — 저장소 맨 위 폴더에서 실행: bash grade/day4.sh (전체 삭제 전에 실행)
p=0; f=0
ok(){ echo "[PASS] $1"; p=$((p+1)); }
ng(){ echo "[FAIL] $1  → 힌트: $2"; f=$((f+1)); }
cd "$(dirname "$0")/.." || exit 1
R=$(git remote get-url origin | sed -E 's#.*github.com[:/]##; s#\.git$##')
API=https://api.github.com/repos/$R
runs(){ curl -fsS "$API/actions/workflows/$1/runs?per_page=50" | jq "[.workflow_runs[] | select(.conclusion==\"$2\")] | length"; }
c=$(curl -fsS "$API/issues/comments?per_page=100" | jq '[.[] | select(.body | contains("Terraform plan"))] | length')
[ "${c:-0}" -ge 1 ] && ok "종합 ②: PR에 plan 코멘트 ${c}건" || ng "PR plan 코멘트 없음" "terraform-pr.yml, 저장소 변수 AWS_ROLE_ARN·TF_STATE_BUCKET"
env=$(curl -fsS "$API/environments" | jq '[.environments[] | select(.name=="production") | .protection_rules[] | select(.type=="required_reviewers")] | length')
a=$(runs terraform-apply.yml success)
[ "${env:-0}" -ge 1 ] && [ "${a:-0}" -ge 1 ] && ok "종합 ②: production 승인 규칙 + apply 성공 ${a}회" || ng "승인 규칙(${env:-0}) 또는 apply 성공(${a:-0}) 없음" "Settings → Environments → production → Required reviewers"
bad=$(runs terraform-pr.yml failure); rows=$(grep -c '^| [0-9]' prompts/log.md 2>/dev/null)
[ "${bad:-0}" -ge 1 ] && [ "${rows:-0}" -ge 8 ] && ok "AI 검증 훈련 ④: 검사가 막은 PR ${bad}건, 기록 누적 ${rows}건" || ng "실패한 PR 검사 ${bad:-0}건, 기록 ${rows:-0}건" "위험 변경 PR을 올려 검사 실패 확인, 기록 누적 8건"
U=$(terraform -chdir=live output -raw url 2>/dev/null)
code=$(curl -s -m 8 -o /dev/null -w '%{http_code}' "$U" 2>/dev/null)
if [ "$code" = 200 ] && [ -f docs/report.md ] && grep -q '구성도' docs/report.md && grep -q '검사' docs/report.md; then
  ok "종합 ③④: 카드 배포 응답 200, 결과 보고서 있음"
else ng "카드 응답 ${code:-없음} 또는 docs/report.md 미완성" "terraform -chdir=live output url, 보고서 템플릿의 제목 유지"; fi
echo "결과: PASS $p / FAIL $f"

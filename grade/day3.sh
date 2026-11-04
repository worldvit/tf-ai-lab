#!/bin/bash
# Day 3 채점 — 저장소 맨 위 폴더에서 실행: bash grade/day3.sh (destroy 전에 실행)
p=0; f=0
ok(){ echo "[PASS] $1"; p=$((p+1)); }
ng(){ echo "[FAIL] $1  → 힌트: $2"; f=$((f+1)); }
cd "$(dirname "$0")/../day3/lab" || exit 1
if terraform validate -no-color >/dev/null 2>&1 && tflint --format compact >/dev/null 2>&1; then
  ok "실습 ①: validate · tflint 통과"
else ng "실습 ①: validate 또는 tflint 오류" "terraform validate, tflint --init 후 tflint"; fi
cf=$(checkov -d . --quiet --compact 2>/dev/null | grep -o 'Failed checks: [0-9]*' | grep -o '[0-9]*$')
trivy config --quiet --exit-code 1 --severity HIGH,CRITICAL . >/dev/null 2>&1; tr=$?
if [ "${cf:-1}" = 0 ] && [ $tr = 0 ]; then
  ok "실습 ②: Checkov 실패 0건, Trivy HIGH·CRITICAL 0건"
else ng "실습 ②: Checkov 실패 ${cf:-?}건, Trivy 종료 코드 $tr" "checkov -d . / trivy config . 결과를 AI에 주고 수정, 예외는 이유와 함께"; fi
if ls tests/*.tftest.hcl >/dev/null 2>&1 && terraform test -no-color 2>&1 | grep -q 'Success!'; then
  ok "실습 ③: terraform test 통과"
else ng "실습 ③: terraform test 실패 또는 테스트 없음" "tests/*.tftest.hcl, terraform test 출력의 error_message"; fi
U=$(terraform output -raw alb_url 2>/dev/null)
c=$(curl -s -m 5 -o /dev/null -w '%{http_code}' "$U" 2>/dev/null)
rows=$(grep -c '^| [0-9]' ../../prompts/log.md 2>/dev/null)
if [ "$c" = 200 ] && [ "${rows:-0}" -ge 6 ]; then
  ok "실습 ③: ALB 응답 200, 기록 누적 ${rows}건"
else ng "ALB 응답 ${c:-없음}, 기록 ${rows:-0}건" "apply 후 대상 그룹 healthy까지 2~3분, 기록은 누적 6건"; fi
echo "결과: PASS $p / FAIL $f"

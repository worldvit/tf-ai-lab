#!/bin/bash
# Day 2 채점 — 저장소 맨 위 폴더에서 실행: bash grade/day2.sh (destroy 전에 실행)
p=0; f=0
ok(){ echo "[PASS] $1"; p=$((p+1)); }
ng(){ echo "[FAIL] $1  → 힌트: $2"; f=$((f+1)); }
cd "$(dirname "$0")/.." || exit 1
L1=day2/lab1
if ls $L1/variables.tf >/dev/null 2>&1 && terraform -chdir=$L1 state list 2>/dev/null | grep -q 'aws_subnet.public\["'; then
  terraform -chdir=$L1 plan -detailed-exitcode -input=false -lock=false >/dev/null 2>&1; rc=$?
  [ $rc = 0 ] && ok "실습 ①: 변수화·for_each 리팩터링 후 plan 변경 없음" || ng "실습 ①: plan에 변경 남음(종료 코드 $rc)" "terraform plan에서 - 또는 ~ 원인 확인, moved 블록"
else ng "실습 ①: variables.tf 또는 for_each 주소 없음" "count → for_each 전환과 moved 블록"; fi
B=$(aws s3api list-buckets --query "Buckets[?starts_with(Name,'tfai-state-')].Name | [0]" --output text)
if [ "$B" != "None" ] && [ "$(aws s3api get-bucket-versioning --bucket $B --query Status --output text)" = Enabled ] \
   && aws s3api head-object --bucket $B --key day2/lab1.tfstate >/dev/null 2>&1; then
  ok "실습 ②: 상태가 S3($B)에 있고 버전 관리 켜짐"
else ng "실습 ②: 원격 상태 없음" "bootstrap/state-bucket apply → backend.tf → init -migrate-state"; fi
U=$(terraform -chdir=day2/envs/dev output -json web_urls 2>/dev/null | jq -r '.[]' 2>/dev/null)
n=0; for u in $U; do [ "$(curl -s -m 5 -o /dev/null -w '%{http_code}' $u)" = 200 ] && n=$((n+1)); done
if terraform -chdir=day2/envs/dev state list 2>/dev/null | grep -q '^module.network' && [ $n -ge 2 ]; then
  ok "실습 ③: 모듈로 만든 웹 서버 ${n}대 응답"
else ng "실습 ③: 응답한 웹 서버 ${n}대" "envs/dev에서 모듈 호출 apply, 2~3분 뒤 output web_urls"; fi
rows=$(grep -c '^| [0-9]' prompts/log.md 2>/dev/null)
[ "${rows:-0}" -ge 4 ] && ok "프롬프트·수정 기록 누적 ${rows}건" || ng "기록 ${rows:-0}건" "Day 2 기록을 2건 이상 더 (누적 4건)"
echo "결과: PASS $p / FAIL $f"

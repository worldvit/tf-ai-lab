#!/bin/bash
# Day 1 채점 — 저장소 맨 위 폴더에서 실행: bash grade/day1.sh (destroy 전에 실행)
p=0; f=0
ok(){ echo "[PASS] $1"; p=$((p+1)); }
ng(){ echo "[FAIL] $1  → 힌트: $2"; f=$((f+1)); }
cd "$(dirname "$0")/.." || exit 1
S1=day1/lab1/terraform.tfstate
if [ -f $S1 ] && [ "$(jq '.serial' $S1)" -ge 2 ] && [ "$(jq '.resources|length' $S1)" = 0 ]; then
  ok "실습 ①: S3 버킷을 만들고 지웠다 (상태 파일 기록 $(jq '.serial' $S1)회)"
else ng "실습 ①: 생성·삭제 기록 없음" "day1/lab1에서 terraform apply → terraform destroy"; fi
L=$(terraform -chdir=day1/lab2 state list 2>/dev/null)
nsub=$(echo "$L" | grep -c '^aws_subnet\.')
if echo "$L" | grep -q '^aws_vpc\.' && [ "$nsub" -ge 4 ] && echo "$L" | grep -q '^aws_internet_gateway\.' && echo "$L" | grep -q '^aws_route_table\.'; then
  ok "실습 ②: VPC · 서브넷 ${nsub}개 · IGW · 라우팅 테이블"
else ng "실습 ②: VPC 구성 부족 (서브넷 ${nsub}개)" "day1/lab2에서 terraform apply, state list 확인"; fi
URL=$(terraform -chdir=day1/lab2 output -raw web_url 2>/dev/null)
code=$(curl -s -m 5 -o /dev/null -w '%{http_code}' "$URL" 2>/dev/null)
[ "$code" = 200 ] && ok "실습 ③: 웹 서버 응답 ($URL)" || ng "실습 ③: 웹 응답 ${code:-없음}" "web.tf apply 후 2~3분 기다리고 output web_url 확인"
rows=$(grep -c '^| [0-9]' prompts/log.md 2>/dev/null)
[ "${rows:-0}" -ge 2 ] && ok "프롬프트·수정 기록 ${rows}건" || ng "프롬프트 기록 ${rows:-0}건" "prompts/log.md에 시각부터 적은 줄을 2개 이상 (예시 줄 제외)"
echo "결과: PASS $p / FAIL $f"

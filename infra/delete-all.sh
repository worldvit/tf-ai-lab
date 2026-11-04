#!/bin/bash
# 전체 삭제 2단계 (CloudShell) — 상태 버킷 비우고 삭제, 작업용 EC2 스택 삭제
# 사용: curl -fsSL https://raw.githubusercontent.com/내아이디/tf-ai-lab/main/infra/delete-all.sh | bash
export AWS_REGION=ap-northeast-2
for B in $(aws s3api list-buckets --query "Buckets[?starts_with(Name,'tfai-')].Name" --output text); do
  echo "== 버킷 $B 비우고 삭제 (모든 버전 포함)"
  while :; do
    J=$(aws s3api list-object-versions --bucket "$B" --max-items 500 \
        --query '{Objects: [Versions[].{Key:Key,VersionId:VersionId}, DeleteMarkers[].{Key:Key,VersionId:VersionId}][]}' --output json 2>/dev/null)
    [ "$(echo "$J" | jq '.Objects | length' 2>/dev/null)" -gt 0 ] 2>/dev/null || break
    aws s3api delete-objects --bucket "$B" --delete "$J" >/dev/null
  done
  aws s3api delete-bucket --bucket "$B" && echo "   삭제됨"
done
if aws cloudformation describe-stacks --stack-name tf-workstation >/dev/null 2>&1; then
  echo "== 작업용 EC2 스택 삭제 (약 3분)"
  aws cloudformation delete-stack --stack-name tf-workstation
  aws cloudformation wait stack-delete-complete --stack-name tf-workstation && echo "   삭제됨"
fi
echo "다음: 정리 확인 — curl -fsSL https://raw.githubusercontent.com/내아이디/tf-ai-lab/main/grade/cleanup-day4.sh | bash"

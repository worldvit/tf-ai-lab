#!/bin/bash
# Day 1 정리 확인 — 저장소 맨 위 폴더에서 실행 (destroy 후)
export AWS_REGION=${AWS_REGION:-ap-northeast-2}
chk(){ [ -z "$2" ] && echo "[OK] $1" || echo "[남음] $1 → $2"; }
chk "Day 1 EC2 없음" "$(aws ec2 describe-instances --filters Name=tag:Course,Values=04 Name=tag:Day,Values=1 Name=instance-state-name,Values=pending,running,stopping,stopped --query 'Reservations[].Instances[].InstanceId' --output text)"
chk "Day 1 VPC 없음" "$(aws ec2 describe-vpcs --filters Name=tag:Course,Values=04 Name=tag:Day,Values=1 --query 'Vpcs[].VpcId' --output text)"
chk "실습 S3 버킷 없음" "$(aws s3api list-buckets --query "Buckets[?starts_with(Name,'tfai-d1-')].Name" --output text)"
for d in day1/lab1 day1/lab2; do
  n=$(terraform -chdir=$d state list 2>/dev/null | wc -l)
  [ "$n" = 0 ] && echo "[OK] $d 상태 비어 있음" || echo "[남음] $d 상태에 리소스 ${n}개 → terraform -chdir=$d destroy"
done
echo "작업용 EC2는 콘솔에서 '인스턴스 중지' (종료 아님)"

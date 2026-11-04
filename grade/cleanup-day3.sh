#!/bin/bash
# Day 3 정리 확인 — 저장소 맨 위 폴더에서 실행 (destroy 후)
export AWS_REGION=${AWS_REGION:-ap-northeast-2}
cd "$(dirname "$0")/.." || exit 1
chk(){ [ -z "$2" ] && echo "[OK] $1" || echo "[남음] $1 → $2"; }
chk "Day 3 EC2 없음" "$(aws ec2 describe-instances --filters Name=tag:Course,Values=04 Name=tag:Day,Values=3 Name=instance-state-name,Values=pending,running,stopping,stopped --query 'Reservations[].Instances[].InstanceId' --output text)"
chk "RDS 없음" "$(aws rds describe-db-instances --query "DBInstances[?starts_with(DBInstanceIdentifier,'tfai-')].DBInstanceIdentifier" --output text)"
chk "ALB 없음" "$(aws elbv2 describe-load-balancers --query "LoadBalancers[?starts_with(LoadBalancerName,'tfai-')].LoadBalancerName" --output text)"
chk "Day 3 VPC 없음" "$(aws ec2 describe-vpcs --filters Name=tag:Course,Values=04 Name=tag:Day,Values=3 --query 'Vpcs[].VpcId' --output text)"
n=$(terraform -chdir=day3/lab state list 2>/dev/null | wc -l)
[ "$n" = 0 ] && echo "[OK] day3/lab 상태 비어 있음" || echo "[남음] day3/lab 상태에 리소스 ${n}개 → terraform -chdir=day3/lab destroy"
echo "[유지] 상태 버킷 (Day 4에서 계속 사용)"
echo "작업용 EC2는 콘솔에서 '인스턴스 중지' (종료 아님)"

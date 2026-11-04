#!/bin/bash
# 최종 정리 확인 (CloudShell) — 과정에서 만든 것이 하나도 남지 않았는지
export AWS_REGION=ap-northeast-2
chk(){ [ -z "$2" ] || [ "$2" = None ] && echo "[OK] $1" || echo "[남음] $1 → $2"; }
chk "Course=04 EC2 없음" "$(aws ec2 describe-instances --filters Name=tag:Course,Values=04 Name=instance-state-name,Values=pending,running,stopping,stopped --query 'Reservations[].Instances[].InstanceId' --output text)"
chk "Course=04 VPC 없음" "$(aws ec2 describe-vpcs --filters Name=tag:Course,Values=04 --query 'Vpcs[].VpcId' --output text)"
chk "RDS 없음" "$(aws rds describe-db-instances --query "DBInstances[?starts_with(DBInstanceIdentifier,'tfai-')].DBInstanceIdentifier" --output text)"
chk "ALB 없음" "$(aws elbv2 describe-load-balancers --query "LoadBalancers[?starts_with(LoadBalancerName,'tfai-')].LoadBalancerName" --output text)"
chk "CloudFront 없음" "$(aws cloudfront list-distributions --query "DistributionList.Items[?contains(Origins.Items[0].DomainName,'tfai-')].Id" --output text)"
chk "tfai 버킷 없음" "$(aws s3api list-buckets --query "Buckets[?starts_with(Name,'tfai-')].Name" --output text)"
chk "GitHub OIDC 공급자 없음" "$(aws iam list-open-id-connect-providers --query "OpenIDConnectProviderList[?contains(Arn,'token.actions.githubusercontent.com')].Arn" --output text)"
chk "배포 역할 없음" "$(aws iam get-role --role-name tfai-github-deploy --query Role.RoleName --output text 2>/dev/null)"
chk "작업용 EC2 스택 없음" "$(aws cloudformation describe-stacks --stack-name tf-workstation --query 'Stacks[0].StackStatus' --output text 2>/dev/null)"
echo "GitHub: 저장소는 남겨도 되지만 토큰(Fine-grained token)은 Settings → Developer settings 에서 삭제"

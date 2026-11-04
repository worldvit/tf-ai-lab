# 심화 2 — import 블록

1. 콘솔 EC2 → 보안 그룹 → 보안 그룹 생성: 이름 `tfai-console-sg`, 기본 VPC, 인바운드 HTTP 80 / 내 IP
2. 이 폴더에서 `terraform init`
3. `terraform plan -var sg_id=sg-xxxx -generate-config-out=generated.tf`
4. generated.tf를 열어 확인 → `terraform apply -var sg_id=sg-xxxx` → `Plan: 1 to import`
5. 다시 plan → 태그(Course·Day)만 추가되는 변경이 보이면 apply
6. 끝나면 `terraform destroy -var sg_id=sg-xxxx` (콘솔에서 만든 보안 그룹도 지워짐)

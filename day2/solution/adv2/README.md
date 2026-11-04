# 심화 2 — import 블록

1. 콘솔 EC2 → 보안 그룹 → 보안 그룹 생성: 이름 `tfai-console-sg`, 기본 VPC, 인바운드 HTTP 80 / 내 IP
2. 이 폴더에서 `terraform init`
3. `terraform plan -var sg_id=sg-xxxx -generate-config-out=generated.tf`
4. generated.tf를 열어 확인(실험 기능이라 초안일 뿐) → `terraform plan -var sg_id=sg-xxxx` → `Plan: 1 to import, 0 to add, 1 to change` (1 change는 default_tags의 Course·Day 태그 추가)
5. `terraform apply -var sg_id=sg-xxxx` → `1 imported, 1 changed` → 다시 plan이 `No changes`면 완료
6. 끝나면 `terraform destroy -var sg_id=sg-xxxx` (콘솔에서 만든 보안 그룹도 지워짐)

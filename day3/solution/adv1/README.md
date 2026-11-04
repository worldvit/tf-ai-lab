# 심화 1 정답 — RDS 비밀번호를 Secrets Manager로

1. `day3/lab/rds.tf`의 `password = var.db_password` 를 `manage_master_user_password = true` 로 바꾼다
2. `variables.tf`에서 `db_password` 변수, `tests/`의 `db_password` 관련 내용을 지운다
3. 이 폴더의 `rds.tf`처럼 `db_secret_arn` 출력을 추가한다
4. `terraform plan` → RDS가 **교체가 아니라 변경(~)** 인지 확인 후 apply
5. 확인
   ```bash
   terraform state pull | grep -c '"password"'       # 비밀번호 값이 남아 있지 않은지 (null만 보임)
   aws secretsmanager describe-secret --secret-id "$(terraform output -raw db_secret_arn)" --query Name
   ```

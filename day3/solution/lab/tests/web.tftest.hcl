# 요구사항을 테스트로 — plan만 하므로 실제 리소스를 만들지 않는다
variables {
  db_password = "test-only-password-1234"
}

run "network" {
  command = plan
  assert {
    condition     = length(aws_subnet.public) == 2 && length(aws_subnet.private) == 2
    error_message = "퍼블릭·프라이빗 서브넷이 각각 2개여야 한다"
  }
}

run "database_is_private_and_encrypted" {
  command = plan
  assert {
    condition     = aws_db_instance.main.publicly_accessible == false
    error_message = "RDS는 퍼블릭 접근이 꺼져 있어야 한다"
  }
  assert {
    condition     = aws_db_instance.main.storage_encrypted == true
    error_message = "RDS 저장 암호화가 켜져 있어야 한다"
  }
}

run "web_servers" {
  command = plan
  assert {
    condition     = aws_launch_template.web.metadata_options[0].http_tokens == "required"
    error_message = "시작 템플릿은 IMDSv2(http_tokens = required)여야 한다"
  }
  assert {
    condition     = aws_autoscaling_group.web.min_size >= 2
    error_message = "웹 서버는 최소 2대"
  }
}

run "short_password_rejected" {
  command = plan
  variables {
    db_password = "short"
  }
  expect_failures = [var.db_password]
}

# 종합 실습 ① — GitHub OIDC 공급자와 배포 역할

AI에게 줄 요구사항:
- `aws_iam_openid_connect_provider`: url `https://token.actions.githubusercontent.com`, client id `sts.amazonaws.com`
- 역할 `tfai-github-deploy`: 신뢰 정책은 `sts:AssumeRoleWithWebIdentity`,
  `aud = sts.amazonaws.com`, `sub` 는 **내 저장소의 `pull_request` 와 `environment:production` 만**
  - 주의: 새로 만든 저장소의 토큰 sub는 `repo:아이디@숫자/저장소@숫자:pull_request` 형식이다.
    AI는 예전 형식(`repo:아이디/저장소:...`)만 알려 주는 경우가 많다. 두 형식을 모두 허용한다
- 권한: `PowerUserAccess` (IAM 변경 불가)
- 변수 `github_repo` (예: `myid/tf-ai-lab`), 출력 `role_arn`
- provider·terraform·backend 블록은 쓰지 않음 (versions.tf, backend.tf 있음)

정답: `day4/solution/oidc/main.tf`

# 종합 실습 ① 정답: GitHub Actions가 키 없이 AWS에 로그인하도록 OIDC 공급자와 배포 역할을 만든다
variable "github_repo" {
  description = "내 저장소 (예: myid/tf-ai-lab)"
  type        = string
  validation {
    condition     = can(regex("^[A-Za-z0-9-]+/[A-Za-z0-9._-]+$", var.github_repo))
    error_message = "github_repo는 \"아이디/저장소\" 형식"
  }
}

locals {
  owner = split("/", var.github_repo)[0]
  repo  = split("/", var.github_repo)[1]
}

# GitHub의 토큰 발급 서버를 계정에 등록 (계정당 URL 하나)
resource "aws_iam_openid_connect_provider" "github" {
  url            = "https://token.actions.githubusercontent.com"
  client_id_list = ["sts.amazonaws.com"]
}

data "aws_iam_policy_document" "trust" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }
    # 내 저장소의 PR 실행과 production 환경 실행만 이 역할을 쓸 수 있다
    # sub 형식은 두 가지: 예전 repo:아이디/저장소:...  새 저장소 repo:아이디@숫자ID/저장소@숫자ID:...
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values = [
        "repo:${local.owner}/${local.repo}:pull_request",
        "repo:${local.owner}/${local.repo}:environment:production",
        "repo:${local.owner}@*/${local.repo}@*:pull_request",
        "repo:${local.owner}@*/${local.repo}@*:environment:production",
      ]
    }
  }
}

resource "aws_iam_role" "deploy" {
  name                 = "tfai-github-deploy"
  assume_role_policy   = data.aws_iam_policy_document.trust.json
  max_session_duration = 3600
}

# 카드 리소스(VPC·EC2·S3·CloudFront) 생성용. IAM은 못 만지게 PowerUser
resource "aws_iam_role_policy_attachment" "poweruser" {
  role       = aws_iam_role.deploy.name
  policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
}

output "role_arn" {
  value = aws_iam_role.deploy.arn
}

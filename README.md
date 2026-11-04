# tf-ai-lab

생성형 AI와 Terraform으로 AWS 인프라를 만드는 4일 실습 저장소. 강사 템플릿이며, 수강생은 **Use this template**으로 자기 GitHub에 **공개(public)** 저장소로 복제해 쓴다.

| 폴더 | 내용 |
|---|---|
| `workstation/` | 작업용 EC2(브라우저 VS Code·Terraform·tflint·Checkov·Trivy) CloudFormation 템플릿 |
| `prompts/` | 요구사항 명세 템플릿, 프롬프트·검증 기록 |
| `dayN/labN/` | 실습 폴더 (versions.tf만 들어 있고, 나머지는 AI와 함께 작성) |
| `dayN/solution/` | 일차별 정답 코드 (처음부터 공개) |
| `grade/` | 일차별 채점·정리 확인 스크립트 |
| `rescue/` | 앞 실습을 못 끝냈을 때 다음 실습 시작점 스크립트 |

## 지키는 것
- 상태 파일(`*.tfstate`)·`.terraform/`·`*.tfvars`는 커밋하지 않는다 (`.gitignore`).
- 액세스 키·비밀번호·계정 ID·상태 파일을 생성형 AI에 붙여 넣지 않는다.
- AI가 쓴 코드는 초안이다. `fmt → validate → plan`으로 확인하고, 인자는 Terraform Registry 문서와 대조한다.

# 카드 A 정답 — 정적 웹사이트 (S3 + CloudFront)

1. `live/main.tf` ← 이 폴더의 `main.tf`
2. 고친 것: 응답 헤더 정책(CKV2_AWS_32, 관리형 정책 ID를 못 알아보는 오탐은 주석으로 건너뜀), 수명 주기 — 이전 버전 30일·미완료 업로드 7일(CKV2_AWS_61, CKV_AWS_300)
3. 실습 예외는 이유와 함께: `cp day4/solution/card-a/.checkov.yaml day4/solution/card-a/.trivyignore live/`
4. CloudFront 생성 약 3분, 삭제 약 3분 (리허설)

# 요구사항 카드 A — 정적 웹사이트 (S3 + CloudFront)

## 요구사항
- S3 버킷 1개에 `index.html`을 올리고 CloudFront로 HTTPS 제공
- 버킷은 퍼블릭 접근 4가지 모두 차단, 저장 암호화, 버전 관리
- CloudFront만 버킷을 읽을 수 있게 OAC(Origin Access Control)와 버킷 정책 사용
- HTTP로 들어오면 HTTPS로 리다이렉트, 기본 문서 index.html
- 출력: `url` (https://...cloudfront.net)
- 코드는 `live/main.tf` 하나, provider·terraform·backend 블록은 쓰지 않음

## 완료 기준
- PR에 plan 코멘트, 검사 통과 → 승인 후 배포
- `curl -s $(terraform output -raw url)` 에 index.html 내용이 보인다
- 버킷 주소로 직접 접근하면 403 (CloudFront로만 열림)

## 참고
- CloudFront 배포는 만드는 데 3~5분, 지우는 데 5~10분 걸린다
- 실습 예외(HTTPS 인증서 외 비용 항목)는 `live/.checkov.yaml`에 이유와 함께 추가

# 요구사항 카드 B — 모듈화된 웹 서버

## 요구사항
- Day 2에 만든 `day2/modules/network`, `day2/modules/compute` 모듈을 재사용
- VPC 10.80.0.0/16, AZ 2개, AZ마다 웹 서버 1대 (t3.micro)
- 이름 접두사 `tfai-live`
- 출력: `url` (첫 번째 웹 서버 주소), `web_urls` (전체)
- 코드는 `live/main.tf` 하나, 모듈 source는 `../day2/modules/...`

## 완료 기준
- PR에 plan 코멘트, 검사 통과 → 승인 후 배포
- `curl -s $(terraform output -raw url)` 에 웹 페이지가 보인다

## 참고
- 모듈 안 리소스도 Checkov·Trivy 검사 대상이다. 결과를 보고 모듈을 고치거나 예외에 이유를 적는다

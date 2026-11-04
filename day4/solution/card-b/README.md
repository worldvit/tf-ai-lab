# 카드 B 정답 — 모듈화된 웹 서버

1. `live/main.tf` ← 이 폴더의 `main.tf`
2. 검사 결과 중 **모듈 안의 결함은 모듈을 고친다** (Day 2 모듈에도 반영됨)
   ```bash
   cp day4/solution/card-b/module-fixes/compute/main.tf day2/modules/compute/main.tf
   cp day4/solution/card-b/module-fixes/network/default_sg.tf day2/modules/network/
   ```
   - CKV_AWS_23 보안 그룹 규칙 설명 · CKV_AWS_8 루트 볼륨 암호화 · CKV2_AWS_12 기본 보안 그룹
3. 설계상 예외는 이유와 함께: `cp day4/solution/card-b/.checkov.yaml day4/solution/card-b/.trivyignore live/`
